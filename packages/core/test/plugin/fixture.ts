import { AgentV2 } from "@openchat-ai/core/agent"
import { AISDK } from "@openchat-ai/core/aisdk"
import { Catalog } from "@openchat-ai/core/catalog"
import { CommandV2 } from "@openchat-ai/core/command"
import { Credential } from "@openchat-ai/core/credential"
import { AppNodeBuilder } from "@openchat-ai/core/effect/app-node-builder"
import { LayerNodePlatform } from "@openchat-ai/core/effect/app-node-platform"
import { LayerNode } from "@openchat-ai/core/effect/layer-node"
import { EventV2 } from "@openchat-ai/core/event"
import { FileSystem } from "@openchat-ai/core/filesystem"
import { FSUtil } from "@openchat-ai/core/fs-util"
import { Integration } from "@openchat-ai/core/integration"
import { Location } from "@openchat-ai/core/location"
import { Npm } from "@openchat-ai/core/npm"
import { PluginV2 } from "@openchat-ai/core/plugin"
import { Reference } from "@openchat-ai/core/reference"
import { SkillV2 } from "@openchat-ai/core/skill"
import { Effect, Layer } from "effect"
import { tempLocationLayer } from "../fixture/location"

const npmLayer = Layer.succeed(
  Npm.Service,
  Npm.Service.of({
    add: () => Effect.succeed({ directory: "", entrypoint: undefined }),
    install: () => Effect.void,
    which: () => Effect.succeed(undefined),
  }),
)

export const PluginTestLayer = AppNodeBuilder.build(
  LayerNode.group([
    FileSystem.node,
    FSUtil.node,
    Location.node,
    Npm.node,
    Credential.node,
    EventV2.node,
    LayerNodePlatform.httpClient,
    PluginV2.node,
    AgentV2.node,
    AISDK.node,
    Catalog.node,
    CommandV2.node,
    Integration.node,
    Reference.node,
    SkillV2.node,
  ]),
  [
    [Location.node, tempLocationLayer],
    [Npm.node, npmLayer],
  ],
)
