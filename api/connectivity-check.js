/**
 * Optional Vercel check: public Polymarket gamma-api (no wallet, no secrets).
 * Max duration ~10s on Vercel hobby.
 */
const https = require("https");

function getJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, { timeout: 8000 }, (r) => {
        let body = "";
        r.on("data", (c) => (body += c));
        r.on("end", () => {
          try {
            resolve(JSON.parse(body));
          } catch (e) {
            reject(e);
          }
        });
      })
      .on("error", reject);
  });
}

module.exports = async (req, res) => {
  res.setHeader("Cache-Control", "no-store");
  try {
    const slug =
      "highest-temperature-in-nyc-on-may-21-2026";
    const data = await getJson(
      `https://gamma-api.polymarket.com/events?slug=${slug}`
    );
    const found = Array.isArray(data) && data.length > 0;
    res.status(200).json({
      status: "ok",
      gammaApiReachable: true,
      sampleEventFound: found,
      note: "Public read-only check. No private keys used.",
      timestamp: new Date().toISOString()
    });
  } catch (e) {
    res.status(502).json({
      status: "degraded",
      gammaApiReachable: false,
      error: String(e.message || e),
      timestamp: new Date().toISOString()
    });
  }
};
