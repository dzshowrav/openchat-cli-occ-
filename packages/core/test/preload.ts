import path from "path"

process.env.OPENCHAT_DB = ":memory:"
process.env.OPENCHAT_MODELS_PATH = path.join(import.meta.dir, "plugin", "fixtures", "models-dev.json")
process.env.OPENCHAT_DISABLE_MODELS_FETCH = "true"
