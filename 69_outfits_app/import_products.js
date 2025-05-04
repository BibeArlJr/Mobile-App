// import_products.js (CommonJS)

const fs = require("fs");
const admin = require("firebase-admin");

// Initialize the Admin SDK
const serviceAccount = JSON.parse(
    fs.readFileSync("./serviceAccountKey.json", "utf8")
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Read and parse your products.json
const raw = fs.readFileSync("products.json", "utf8");
const all = JSON.parse(raw).products;

async function run() {
    const batch = db.batch();
    for (const [id, data] of Object.entries(all)) {
        const ref = db.collection("products").doc(id);
        batch.set(ref, data);
    }
    await batch.commit();
    console.log("Imported", Object.keys(all).length, "products.");
}

run().catch(console.error);
