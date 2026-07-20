import { Config } from "effect"

export function truthy(key: string) {
  const value = process.env[key]?.toLowerCase()
  return value === "true" || value === "1"
}

const copy = process.env["OPENCHAT_EXPERIMENTAL_DISABLE_COPY_ON_SELECT"]
const fff = process.env["OPENCHAT_DISABLE_FFF"]

function enabledByExperimental(key: string) {
  return process.env[key] === undefined ? truthy("OPENCHAT_EXPERIMENTAL") : truthy(key)
}

export const Flag = {
  OTEL_EXPORTER_OTLP_ENDPOINT: process.env["OTEL_EXPORTER_OTLP_ENDPOINT"],
  OTEL_EXPORTER_OTLP_HEADERS: process.env["OTEL_EXPORTER_OTLP_HEADERS"],

  OPENCHAT_AUTO_HEAP_SNAPSHOT: truthy("OPENCHAT_AUTO_HEAP_SNAPSHOT"),
  OPENCHAT_GIT_BASH_PATH: process.env["OPENCHAT_GIT_BASH_PATH"],
  OPENCHAT_CONFIG: process.env["OPENCHAT_CONFIG"],
  OPENCHAT_CONFIG_CONTENT: process.env["OPENCHAT_CONFIG_CONTENT"],
  OPENCHAT_DISABLE_AUTOUPDATE: truthy("OPENCHAT_DISABLE_AUTOUPDATE"),
  OPENCHAT_ALWAYS_NOTIFY_UPDATE: truthy("OPENCHAT_ALWAYS_NOTIFY_UPDATE"),
  OPENCHAT_DISABLE_PRUNE: truthy("OPENCHAT_DISABLE_PRUNE"),
  OPENCHAT_DISABLE_TERMINAL_TITLE: truthy("OPENCHAT_DISABLE_TERMINAL_TITLE"),
  OPENCHAT_SHOW_TTFD: truthy("OPENCHAT_SHOW_TTFD"),
  OPENCHAT_DISABLE_AUTOCOMPACT: truthy("OPENCHAT_DISABLE_AUTOCOMPACT"),
  OPENCHAT_DISABLE_MODELS_FETCH: truthy("OPENCHAT_DISABLE_MODELS_FETCH"),
  OPENCHAT_DISABLE_MOUSE: truthy("OPENCHAT_DISABLE_MOUSE"),
  OPENCHAT_FAKE_VCS: process.env["OPENCHAT_FAKE_VCS"],
  OPENCHAT_SERVER_PASSWORD: process.env["OPENCHAT_SERVER_PASSWORD"],
  OPENCHAT_SERVER_USERNAME: process.env["OPENCHAT_SERVER_USERNAME"],
  OPENCHAT_DISABLE_FFF: fff === undefined ? process.platform === "win32" : truthy("OPENCHAT_DISABLE_FFF"),

  // Experimental
  OPENCHAT_EXPERIMENTAL_FILEWATCHER: Config.boolean("OPENCHAT_EXPERIMENTAL_FILEWATCHER").pipe(
    Config.withDefault(false),
  ),
  OPENCHAT_EXPERIMENTAL_DISABLE_FILEWATCHER: Config.boolean("OPENCHAT_EXPERIMENTAL_DISABLE_FILEWATCHER").pipe(
    Config.withDefault(false),
  ),
  OPENCHAT_EXPERIMENTAL_DISABLE_COPY_ON_SELECT:
    copy === undefined ? process.platform === "win32" : truthy("OPENCHAT_EXPERIMENTAL_DISABLE_COPY_ON_SELECT"),
  OPENCHAT_MODELS_URL: process.env["OPENCHAT_MODELS_URL"],
  OPENCHAT_MODELS_PATH: process.env["OPENCHAT_MODELS_PATH"],
  OPENCHAT_DB: process.env["OPENCHAT_DB"],

  OPENCHAT_WORKSPACE_ID: process.env["OPENCHAT_WORKSPACE_ID"],
  OPENCHAT_EXPERIMENTAL_WORKSPACES: enabledByExperimental("OPENCHAT_EXPERIMENTAL_WORKSPACES"),

  // Evaluated at access time (not module load) because tests, the CLI, and
  // external tooling set these env vars at runtime.
  get OPENCHAT_DISABLE_PROJECT_CONFIG() {
    return truthy("OPENCHAT_DISABLE_PROJECT_CONFIG")
  },
  get OPENCHAT_EXPERIMENTAL_REFERENCES() {
    return enabledByExperimental("OPENCHAT_EXPERIMENTAL_REFERENCES")
  },
  get OPENCHAT_TUI_CONFIG() {
    return process.env["OPENCHAT_TUI_CONFIG"]
  },
  get OPENCHAT_CONFIG_DIR() {
    return process.env["OPENCHAT_CONFIG_DIR"]
  },
  get OPENCHAT_PURE() {
    return truthy("OPENCHAT_PURE")
  },
  get OPENCHAT_PERMISSION() {
    return process.env["OPENCHAT_PERMISSION"]
  },
  get OPENCHAT_PLUGIN_META_FILE() {
    return process.env["OPENCHAT_PLUGIN_META_FILE"]
  },
  get OPENCHAT_CLIENT() {
    return process.env["OPENCHAT_CLIENT"] ?? "cli"
  },
}
