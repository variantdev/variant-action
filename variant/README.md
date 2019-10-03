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
action "Run Variant Task" {
  #uses = "mumoshu/github-actions/variant@master"
  uses = "docker://mumoshu/github-actions-variant:dev""

  # See Environment Variables below for details.
  env = {
    VARIANT_WORKING_DIR = "."
    VARIANT_COMMENT = "true"
  }

  # We need the GitHub token to be able to comment back on the pull request.
  secrets = ["GITHUB_TOKEN"]

  args = ""
}
```

## Environment Variables

*VARIANT_WORKIND_DIR*: Which directory `variant` runs in. Relative to the root of the repo. Default: `.`

*VARIANT_COMMENT*: Set to "false" to disable commenting back on pull on error. Default: `true`

*VARIANT_NAME*: Name of your application that is shown in error messages sent via GitHub issue/pr comments. Default: `variant`

## Secrets

`GITHUB_TOKEN`: Required for posting a comment back to the pull request if `variant` fails.

If you have set `VARIANT_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.
