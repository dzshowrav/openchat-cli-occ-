const stage = process.env.SST_STAGE || "dev"

export default {
  url: stage === "production" ? "https://openchat.ai" : `https://${stage}.openchat.ai`,
  console: stage === "production" ? "https://openchat.ai/auth" : `https://${stage}.openchat.ai/auth`,
  email: "help@anoma.ly",
  socialCard: "https://social-cards.sst.dev",
  github: "https://github.com/anomalyco/openchat",
  discord: "https://openchat.ai/discord",
  headerLinks: [
    { name: "app.header.home", url: "/" },
    { name: "app.header.docs", url: "/docs/" },
  ],
}
