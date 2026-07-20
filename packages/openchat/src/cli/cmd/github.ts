import { effectCmd } from "../effect-cmd"
import type { SessionV1 } from "@openchat-ai/core/v1/session"

export const GithubCommand = effectCmd({
  command: "github",
  describe: "manage GitHub integration",
  instance: false,
  handler: () => {},
})

export function extractResponseText(parts: SessionV1.Part[]): string | null {
  if (!parts.length) throw new Error("no parts returned")
  const text = parts.findLast((p) => p.type === "text")
  if (text && text.type === "text") return text.text
  if (parts.some((p) => p.type === "text")) return null
  return null
}

export function formatPromptTooLargeError(files: { filename: string; content: string }[]): string {
  let msg = "PROMPT_TOO_LARGE: The prompt exceeds the model's context limit."
  if (files.length) {
    msg += "\nFiles in prompt:\n" + files.map((f) => `  ${f.filename} (${Math.round((f.content.length * 0.75) / 1024)} KB)`).join("\n")
  }
  return msg
}
