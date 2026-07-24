{
  agents: {
    list: [
      {
        id: "kibs",
        runtime: {
          type: "acp",
          acp: {
            agent: "kibs",
            backend: "acpx",
            mode: "persistent",
            cwd: "/workspace/kibs",
          },
        },
      },
      {
        id: "codex",
        runtime: {
          type: "acp",
          acp: {
            agent: "codex",
            backend: "acpx",
            mode: "persistent",
            cwd: "/workspace/kibs",
          },
        },
      },
      {
        id: "claude",
        runtime: {
          type: "acp",
          acp: {
            agent: "claude",
            backend: "acpx",
            mode: "persistent",
            cwd: "/workspace/kibs",
          },
        },
      },
    ],
  },

  bindings: [
    {
      type: "acp",
      agentId: "codex",
      match: {
        channel: "discord",
        accountId: "default",
        peer: {
          kind: "channel",
          id: "222222222222222222",
        },
      },
      acp: {
        label: "kibs-codex",
        cwd: "/workspace/kibs",
      },
    },

    {
      type: "acp",
      agentId: "claude",
      match: {
        channel: "telegram",
        accountId: "default",
        peer: {
          kind: "group",
          id: "-1001234567890:topic:42",
        },
      },
      acp: {
        label: "kibs-claude",
        cwd: "/workspace/kibs",
      },
    },

    {
      type: "route",
      agentId: "kibs",
      match: {
        channel: "discord",
        accountId: "default",
      },
    },

    {
      type: "route",
      agentId: "kibs",
      match: {
        channel: "telegram",
        accountId: "papperweb",
      },
    },
  ],

  channels: {
    discord: {
      guilds: {
        "111111111111111111": {
          channels: {
            "222222222222222222": {
              requireMention: false,
            },
          },
        },
      },
    },

    telegram: {
      groups: {
        "-1001234567890": {
          topics: {
            "42": {
              requireMention: false,
            },
          },
        },
      },
    },
  },
}
