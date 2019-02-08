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
  uses = "mumoshu/github-actions/variant@master"
  args = ""
}
```
