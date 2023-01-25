**Add a cover photo like:**

![placeholder image](../020/codedeploy.png)

# Deployment Groups and Configurations

## Introduction

✍️ As a Devop Engineer you may want to control how changes are released. For example, you may want to test changes in a dev environment before releasing to production. Also, taking down all the ec2s at once could be detrimental. In that case, you may only want to release changes to ec2 at a certain rate. Hence the need for Groups and Configurations.

## Prerequisite

✍️ Understanding how to navigate the CodePipeline menus

## Use Case

- Controlling what you release.
- Controlling how you release it.

## Cloud Research

- ✍️ Following the Devops course 2022, by Stephae Maarek


### Step 1 —Fix mistake from the day before
This wasn't a mistake as much as I didn't put in the http vs https. Everything from yesterday is working well.

![Screenshot](step1_fix_error.png)

### Step 2 — Launch More Instances to test
From the ec2 menu, right click on the instance and in the Image and template menu choose launch more like this

![Screenshot](step2_launch_more.png)

### Step 3 — Launch 4 instances
choose 4 instances for test purposes

![Screenshot](step3a_instances.png)

### Step 4 — Add this shell script to details

![Screenshot](step3_advance_detail.png)

### Step 5 — Launch

![Screenshot](step4_launch.png)

### Step 6 — Create Deployment Group
Click on the application and click Create Deployment Group
![Screenshot](step5_click_app_create_new_deply_group.png)

### Step 7 — Edit the tags under Environment Variables
Add Production under Environment key
![Screenshot](step5_edit_env_vars.png)

### Step 8 — Name The Deployment and Choose Service Role

![Screenshot](step6_name_role.png)

### Step 9 — Uncheck Enable load balancing and create deployment group

![Screenshot](step7_create_dply_grp.png)

![Screenshot](step8_different_dply_grps.png)

### Step 10 — Select the MyProductionInstances

![Screenshot](step9_select_dplymt.png)

### Step 11 — Edit Deployment

![Screenshot](step10_edit.png)

### Step 12 — Create Deployment Configuration
We will create a production configurtion

![Screenshot](step11_create_config.png)

### Step 14 — Name the Configuration and Enter 80 in the value (%)

![Screenshot](step11_dply_config.png)

### Step 15 — Choose the Configuration You just Created

![Screenshot](step12_choose_custom_dply.png)

### Step 16 — Save Changes

![Screenshot](step14_save_changes.png)

### Step 17 — Create Deployment

![Screenshot](step15_create_dply.png)

### Step 18 — Deployment Settings
Give it a name

![Screenshot](step17_dplysettings.png)


### Step 19 — Create Deployment

![Screenshot](step18_create-dply.png)

### Step 20 — Failed Deployment, need more instances for this to work. For now change configuration

![Screenshot](step19_need_3_instances.png)

### Step 21 — Edit MyProductionInstance
Choose group instances and click edit

![Screenshot](step20_edit_dply_grp.png)

![Screenshot](step21_edit_grp.png)

### Step 22 — Change Deployment Settings to One at a time

![Screenshot](step21_one_ata_time.png)

### Step 23 — Create Deployment

![Screenshot](step22_create_deployment.png)

### Step 24 — Change Deployment Settings to One at a time

![Screenshot](step21_one_ata_time.png)

### Step 25 — Check Settings one more time

![Screenshot](step23_dply-setting_again.png)

![Screenshot](step24_create_deployment.png)

### Step 20 — Success

![Screenshot](step24-installing_success.png)

## ☁️ Cloud Outcome

✍️ Overall I learned how and why you need different groups and configurations. This I'm sure will be revisited. I did look at blue/green deployments, but will delve into that more later.

## Next Steps

✍️ Next up taking a closer look at appspec.yml and hooks.

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[tweet](https://twitter.com/DemianJennings/status/1618112192699854849)

[LinkedIn](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-aws-awspipeline-activity-7023878951970172928-3s4U?utm_source=share&utm_medium=member_desktop)
