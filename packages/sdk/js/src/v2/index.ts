export * from "./client.js"
export * from "./server.js"

import { createOpenchatClient } from "./client.js"
import { createOpenchatServer } from "./server.js"
import type { ServerOptions } from "./server.js"

export * as data from "./data.js"

export async function createOpenchat(options?: ServerOptions) {
  const server = await createOpenchatServer({
    ...options,
  })

  const client = createOpenchatClient({
    baseUrl: server.url,
  })

  return {
    client,
    server,
  }
}
