

![placeholder image](codebuild.png)

# CodeBuild

## Introduction

✍️ Codebuild is another component of building an AWS pipeline. It is similar to jenkins. As per factory Docs:
AWS CodeBuild is a fully managed build service in the cloud. CodeBuild compiles your source code, runs unit tests, and produces artifacts that are ready to deploy. CodeBuild eliminates the need to provision, manage, and scale your own build servers. It provides prepackaged build environments for popular programming languages and build tools such as Apache Maven, Gradle, and more. You can also customize build environments in CodeBuild to use your own build tools. CodeBuild scales automatically to meet peak build requests.

## Prerequisite

✍️ General knowledge of AWS. 

## Use Case

- In a code pipeline, CodeBuild performs the Build and test function.

## Cloud Research

- My material for research comes from AWS Codebuild documentation and videos 13-20 in AWS certified DevOps Engineer Professional 2022 course

## Try yourself


### Step 1 — Create Project
Create a project in CodeBuild

![Screenshot](step1_create_project.png)

### Step 2 — Name Project

![Screenshot](step1a_project_config.png)

### Step 3 — Choose Source Repo
Here I choose the project that I'm continuing to work on.

![Screenshot](step2_Source.png)

### Step 4 — Choose Environment

![Screenshot](step3_environment.png)

### Step 5 — Set Basic Configurations
![Screenshot](step3a_add_config.png)

### Step 6 — Remaining Configurations

![Screenshot](step4_rest_config.png)
### Step 7 — Setting Completed

![Screenshot](step5_created_project.png)

### Step 8 — Start Build

![Screenshot](step6_startbuild.png)

### Step 9 — Completed Build
![Screenshot](step7_completed_build.png)

### Step 10 — Inspect Cloudwatch Logs
![Screenshot](step7a_cloudwatch_logs.png)

### Step 11 — Testing for Errors
In our buildspec.yml file under commands. We are grepping for the word "congratulations". Here will intentionally remove that from our html file. We are expecting that the build will fail. So we are testing it.

![Screenshot](step8_test_for_error.png)

![Screenshot](step8a_build_command.png)

### Step 12 — Build Failure
As expected the build fails

![Screenshot](step8b_failure.png)

### Step 13 — Using Parameters
Utilizing AWS Parameter Store is a more secure way to handle sensitive data such as passwords and database keys

![Screenshot](step9_create_parameter.png)

### Step 14 — Parameter Details
Here I'm providing the name as /Prod/DbPassword. So DbPassword will be stored in the Encrypted Prod folder

![Screenshot](step10_parameterdetails.png)

### Step 15 — Attaching the ssm iam policy

![Screenshot](step11_attach_ssm_iam_policy.png)

### Step 16 — Creating Artifacts
Artifacts are items that are created from the build project. This is how that would be done.
In our case we are saving any file in our repository just as an arbitrary test case.

![Screenshot](step13-add_artifact.png)

### Step 17 — Edit build to add Artifact

![Screenshot](step14_edit_artifacts.png)

### Step 18 — Store Artifacts in S3 bucket

![Screenshot](step15_create-bucket.png)

### Step 19 — Bucket Configurations

![Screenshot](step15a_s3.png)

## Step 20 — Edit Artifacts

![Screenshot](step17_update_artifacts.png)

## Step 21 — Creating an Eventbridge Event

![Screenshot](step19_eventbridge.png)

## Step 22 — Define a Rule setting

![Screenshot](step20_rule_settings.png)

## Step 23 — Configurations

![Screenshot](step21_schedule_pattern.png)

## Step 24 — Invoke a target
In our case I'm using a Lambda function

![Screenshot](step22_invoke_target.png)

## Step 25 — Permissions

![Screenshot](step23_permissions.png)

## Step 20 — Review Schedule

![Screenshot](step24_review.png)


## ☁️ Cloud Outcome

✍️ Overall, After completing this deepdive I feel that I have a good grasp on codeBuild. The tutorial that I was using, utilized cloudwatch events. Cloudwatch events are being deprecated and moving to EventBridge. So this was a good time to get familiar with Eventbridge.

## Next Steps

✍️ CodeDeploy deep dive.

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[tweet](https://twitter.com/DemianJennings/status/1601707256579428354)
[linkedIn](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-100daysofcloud-activity-7007474628872871936-Puia?utm_source=share&utm_medium=member_desktop)
