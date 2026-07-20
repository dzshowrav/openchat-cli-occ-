// @ts-nocheck

import { OpenCode } from "@openchat-ai/core"
import { ReadTool } from "@openchat-ai/core/tools"

const openchat = OpenCode.make({})

openchat.tool.add(ReadTool)

openchat.tool.add({
  name: "bash",
  schema: {
    type: "object",
    properties: {
      command: {
        type: "string",
        description: "The command to run.",
      },
    },
    required: ["command"],
  },
  execute(input, ctx) {},
})

openchat.auth.add({
  provider: "openai",
  type: "api",
  value: process.env.OPENAI_API_KEY,
})

openchat.agent.add({
  name: "build",
  permissions: [],
  model: {
    id: "gpt-5-5",
    provider: "openai",
    variant: "xhigh",
  },
})

const sessionID = await openchat.session.create({
  agent: "build",
})

openchat.subscribe((event) => {
  console.log(event)
})

await openchat.session.prompt({
  sessionID,
  text: "hey what is up",
})

await openchat.session.prompt({
  sessionID,
  text: "what is up with this",
  files: [
    {
      mime: "image/png",
      uri: "data:image/png;base64,xxxx",
    },
  ],
})

await openchat.session.wait()

console.log(await openchat.session.messages(sessionID))
