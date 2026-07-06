// Seed data for the mongodb probe: estimatedDocumentCount over these docs.
db = db.getSiblingDB("demo");
db.events.insertMany([
  { kind: "signup", at: new Date() },
  { kind: "deploy", at: new Date() },
  { kind: "alert", at: new Date() },
]);
