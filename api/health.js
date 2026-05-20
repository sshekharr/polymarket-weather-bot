/**
 * Vercel serverless — health & security notice only.
 * DO NOT set POLYMARKET_PRIVATE_KEY on Vercel for this project.
 */
module.exports = (req, res) => {
  res.setHeader("Cache-Control", "no-store");
  res.status(200).json({
    status: "ok",
    service: "polymarket-weather-bot",
    vercelRole: "monitoring-only",
    liveTradingOnVercel: false,
    reason:
      "Live trading needs long-running Node, local .env, and a burner wallet — use Docker or scripts/run-production.bat instead.",
    security: {
      neverSetOnVercel: ["POLYMARKET_PRIVATE_KEY", "POLYMARKET_PROXY_WALLET_ADDRESS"],
      blockedMalwarePackages: ["sleek-pretty", "pinno-loggers", "terminal-logger-utils"]
    },
    docs: {
      gettingStarted: "/docs/GETTING_STARTED.md",
      docker: "/docs/DOCKER.md",
      vercel: "/docs/VERCEL.md"
    },
    timestamp: new Date().toISOString()
  });
};
