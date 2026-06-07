const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Export the scrapers (to be implemented)
// const { scrapeOnePieceOfficial } = require("./scrapers/onePieceOfficialScraper");
// const { scrapeLigaOnePiece } = require("./scrapers/ligaOnePieceScraper");

// Schedule: runs twice daily at 12:00 and 18:00 (America/Sao_Paulo timezone)
exports.scheduledScraper = functions.pubsub
  .schedule("0 12,18 * * *")
  .timeZone("America/Sao_Paulo")
  .onRun(async (context) => {
    console.log("Starting scheduled scrape job...");
    // TODO: implement and call scrapeOnePieceOfficial()
    // TODO: implement and call scrapeLigaOnePiece()
    // TODO: update firestore and price history
    console.log("Scrape job completed.");
    return null;
  });
