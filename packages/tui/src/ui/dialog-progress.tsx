import { TextAttributes } from "@opentui/core"
import { useTheme } from "../context/theme"
import { useDialog, type DialogContext } from "./dialog"
import { createSignal, createEffect, onCleanup } from "solid-js"

export type DialogProgressResult = "completed" | "cancelled"

export function DialogProgress(props: {
  title: string
  message: string
  duration: number
  onComplete: () => void
}) {
  const dialog = useDialog()
  const { theme } = useTheme()
  const [progress, setProgress] = createSignal(0)

  createEffect(() => {
    const start = Date.now()
    let alive = true
    const id = setInterval(() => {
      const elapsed = Date.now() - start
      setProgress(Math.min(elapsed / props.duration, 1))
      if (elapsed >= props.duration && alive) {
        alive = false
        clearInterval(id)
        props.onComplete()
        dialog.clear()
      }
    }, 50)
    onCleanup(() => {
      alive = false
      clearInterval(id)
    })
  })

  const BAR_WIDTH = 40
  const filled = () => Math.round(progress() * BAR_WIDTH)
  const remaining = () => Math.max(0, (props.duration - progress() * props.duration) / 1000)

  return (
    <box paddingLeft={2} paddingRight={2} gap={1}>
      <box flexDirection="row" justifyContent="space-between">
        <text attributes={TextAttributes.BOLD} fg={theme.text}>
          {props.title}
        </text>
        <text fg={theme.textMuted} onMouseUp={() => dialog.clear()}>
          esc
        </text>
      </box>

      <box paddingBottom={1}>
        <text fg={theme.textMuted}>{props.message}</text>
      </box>

      <box flexDirection="row" gap={1} alignItems="center" paddingBottom={1}>
        <box width={BAR_WIDTH} height={1} backgroundColor={theme.surfaceAlt}>
          <box width={filled()} height={1} backgroundColor={theme.primary} />
        </box>
        <text fg={theme.textMuted}>
          {progress() >= 1 ? "Done!" : `${remaining().toFixed(1)}s`}
        </text>
      </box>

      <box>
        <text fg={theme.textMuted}>
          {progress() >= 1 ? "" : "Press Esc to cancel"}
        </text>
      </box>
    </box>
  )
}

DialogProgress.show = (
  dialog: DialogContext,
  title: string,
  message: string,
  duration = 10000,
) => {
  return new Promise<DialogProgressResult>((resolve) => {
    dialog.replace(
      () => (
        <DialogProgress
          title={title}
          message={message}
          duration={duration}
          onComplete={() => resolve("completed")}
        />
      ),
      () => resolve("cancelled"),
    )
  })
}
