import { run as runTui, type TuiInput } from "@openchat-ai/tui"
import { Global } from "@openchat-ai/core/global"
import { AppNodeBuilder } from "@openchat-ai/core/effect/app-node-builder"
import { Effect } from "effect"

export function run(input: TuiInput) {
  return runTui(input).pipe(Effect.provide(AppNodeBuilder.build(Global.node)))
}
