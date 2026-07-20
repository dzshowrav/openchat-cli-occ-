import { getComponentCatalogue } from "@opentui/solid/components"
import { registerSpinner } from "opentui-spinner/solid"

export function registerOpenchatSpinner() {
  if (!getComponentCatalogue().spinner) registerSpinner()
}
