/// <reference path="../markdown.d.ts" />

export * as SkillPlugin from "./skill"

import { define } from "./internal"
import { Effect } from "effect"
import { AbsolutePath } from "../schema"
import { SkillV2 } from "../skill"
import customizeOpenchatContent from "./skill/customize-openchat.md" with { type: "text" }

export const CustomizeOpenchatContent = customizeOpenchatContent

export const Plugin = define({
  id: "skill",
  effect: Effect.fn(function* (ctx) {
    yield* ctx.skill.transform((draft) => {
      draft.source(
        SkillV2.EmbeddedSource.make({
          type: "embedded",
          skill: SkillV2.Info.make({
            name: "customize-openchat",
            description:
              "Use ONLY when the user is editing or creating openchat's own configuration: openchat.json, openchat.jsonc, files under .openchat/, or files under ~/.config/openchat/. Also use when creating or fixing openchat agents, subagents, commands, skills, plugins, MCP servers, or permission rules. Do not use for the user's own application code, or for any project that is not configuring openchat itself.",
            location: AbsolutePath.make("/builtin/customize-openchat.md"),
            content: CustomizeOpenchatContent,
          }),
        }),
      )
    })
  }),
})
