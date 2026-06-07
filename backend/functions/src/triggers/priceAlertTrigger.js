const functions = require('firebase-functions');
const admin = require('firebase-admin');

// This trigger runs whenever a price_history document is created/updated
// Or it can be run iteratively at the end of the Cron Job
async function checkPriceAlerts(cardId, newMinPrice) {
  const db = admin.firestore();
  
  // Find users who have this card in their wantlist with alertActive = true
  // This requires a collectionGroup query or iterating users. 
  // For efficiency, we assume a collectionGroup or an index on wantlist array.
  // NOTE: Firestore doesn't easily query nested array objects directly by fields inside the objects.
  // In production, wantlist items might be subcollections for easy querying: users/{uid}/wantlist/{cardId}
  
  const wantlistQuery = await db.collectionGroup('wantlist')
    .where('cardId', '==', cardId)
    .where('alertActive', '==', true)
    .get();

  const notifications = [];

  wantlistQuery.forEach((doc) => {
    const data = doc.data();
    const lastKnown = data.lastKnownMinPrice;

    if (lastKnown > 0) {
      const percentageChange = Math.abs((newMinPrice - lastKnown) / lastKnown);
      
      // If price dropped by 30% or more
      if (percentageChange >= 0.30 && newMinPrice < lastKnown) {
        // Construct notification
        const uid = doc.ref.parent.parent.id; // get user ID from path
        notifications.push({
          uid,
          cardId,
          oldPrice: lastKnown,
          newPrice: newMinPrice
        });
      }
    }
  });

  // Send FCM Notifications (Mock)
  for (const notif of notifications) {
    console.log(`Sending Push Notification to User ${notif.uid}: Card ${notif.cardId} dropped 30%! New price: R$ ${notif.newPrice}`);
    // await admin.messaging().sendToDevice(userToken, payload);
  }
}

module.exports = { checkPriceAlerts };
