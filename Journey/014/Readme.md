**CodePipeline**
![AWS CodeCommit](../013/architecture.png)

# AWS CodeCommit Basics - Branches, Pull requests  and IAM Groups

## Introduction

✍️ Review the basics of CodeCommit. Creating branches, pull requests and limiting repository actions through IAM groups

## Prerequisite

✍️ You should have a basic idea of git and github is helpful. You should know the basics of IAM.

## Use Case

- Creating branches and pull requests is a best practice when working in teams. It gives the manager a chance to review the code before merging it into the repository.

## Cloud Research

- CodeCommit is very similar to github. So if you know how that works, Codecommit is very similar.


### Step 1 — checkout a new branch
- git checkout -b my-feature-2

### Step 2 — Make a change to file/files
(here I'm changing the version on line 29)
![Screenshot](html_change.png)

### Step 3 — Add changes
- git add .

### Step 4 — commit changes
 - git commit -m "Changed to v4"

### Step 5 — push changes to upstream branch
- git push --set-upstream origin my-feature-2

![Screenshot](git_cli_ops.png)

### Step 6 — Branch listed in aws repositories

![Screenshot](new_branch.png)

### Step 7 — Create Pull request

![Screenshot](create_pr.png)

### Step 8 - Give it a name
![Screenshot](titel_pr_create.png)

### Step 9 - Merge pull request
![Screenshot](review_changes.png)

### Step 10 - Complete merge
![Screenshot](complete_merge_pr.png)

### Step 11 - merge success
![Screenshot](merge_success_pr.png)

## Creating User groups

### Step 12 - create group
![Screenshot](create_group.png)

### Step 13 - name group
![Screenshot](name_group.png)

### Step 14 - create policy
![Screenshot](create_inline_policy.png)

### Step 15 - edit policy
![Screenshot](edit_policy.png)

### Step 16 - name policy
![Screenshot](give_it_a_name.png)

### Step 17 - Attach policy to junior_devs group

## ☁️ Cloud Outcome

✍️ I have used github, so this was a review. But its important to go back over the fundamentals every once in awhile.

## Next Steps

✍️ creating triggers and notifications in CodeCommit

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[tweet](https://twitter.com/DemianJennings/status/1591499819826167810)

[linkedIn](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-aws-activity-6997266177890693120-E0lE?utm_source=share&utm_medium=member_desktop)
