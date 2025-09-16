// functions/src/index.ts

import { setGlobalOptions } from "firebase-functions/v2";
setGlobalOptions({ region: "europe-west1" });

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

initializeApp();

export const onTxCreated = onDocumentCreated(
    "accounts/{accId}/transactions/{txId}",
    async (event) => {
        const { accId, txId } = event.params as { accId: string; txId: string };

        const snap = event.data;
        if (!snap) {
            console.log("❌ Event snapshot boş geldi");
            return;
        }
        const tx = snap.data() as any;
        if (!tx) {
            console.log("❌ Transaction datası yok");
            return;
        }

        const creatorUid: string | undefined = tx.createdBy;
        if (!creatorUid) {
            console.log("❌ createdBy alanı yok");
            return;
        }

        const db = getFirestore();
        const usersSnap = await db
            .collection("accounts")
            .doc(accId)
            .collection("users")
            .get();

        const otherUids = usersSnap.docs.map((d) => d.id).filter((uid) => uid !== creatorUid);
        console.log("👥 Bildirim gönderilecek kullanıcılar:", otherUids);

        if (otherUids.length === 0) return;

        const tokenFetches = otherUids.map(async (uid) => {
            const uDoc = await db.collection("users").doc(uid).get();
            return uDoc.exists ? (uDoc.data()?.token as string | undefined) : undefined;
        });

        const tokensRaw = await Promise.all(tokenFetches);
        const tokens = tokensRaw.filter((t): t is string => !!t);
        console.log("📲 Bulunan FCM tokenlar:", tokens);

        if (tokens.length === 0) return;

        const typeText = String(tx.type ?? "").toLowerCase();
        const amountText = typeof tx.amount === "number" ? String(tx.amount) : "";
        const title = "Yeni işlem";
        const body = `${typeText} tipli ${amountText} değerinde işlem eklendi`;

        const messaging = getMessaging();

        const resp = await messaging.sendEachForMulticast({
            tokens,
            notification: { title, body },
            data: { accId, txId, type: String(tx.type ?? ""), amount: amountText },
            android: { priority: "high", notification: { channelId: "transactions" } },
            apns: { payload: { aps: { sound: "default", contentAvailable: true } } },
        });

        console.log("✅ Bildirim gönderim sonucu:", JSON.stringify(resp, null, 2));
    }
);