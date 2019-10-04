# Usage

Add the following `Variantfile` to the project root:

```
parameters:
- name: event
  type: object
  default: "/github/workflow/event.json"
script: |
  cat <<EOF
  {{ get "event" | toYaml }}
  EOF
```

Add the following action to your workflow:

```
name: Do something
on:
  # https://help.github.com/en/articles/events-that-trigger-workflows#pull-request-event-pull_request
  pull_request:
    # Defaults to [opened, synchronize, reopened] so specifically set types when you want more:
    types: [opened, reopened, edited, milestoned, demilestoned, labeled, unlabeled, synchronize ]
  # https://help.github.com/en/articles/events-that-trigger-workflows#issues-event-issues
  issues:
    types: [opened, reopened, edited, milestoned, demilestoned, labeled, unlabeled]

jobs:
  run:
    name: variant
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v1
    - uses: variantdev/variant-action@v0.3.4
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VARIANT_WORKING_DIR: "."
        VARIANT_COMMENT: "true"
      with:
        #args: up --build --pull-request
```

## Environment Variables

*VARIANT_WORKIND_DIR*: Which directory `variant` runs in. Relative to the root of the repo. Default: `.`

*VARIANT_COMMENT*: Set to "false" to disable commenting back on pull on error. Default: `true`

*VARIANT_NAME*: Name of your application that is shown in error messages sent via GitHub issue/pr comments. Default: `variant`

## Secrets

`GITHUB_TOKEN`: Required for posting a comment back to the pull request if `variant` fails.

If you have set `VARIANT_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.
