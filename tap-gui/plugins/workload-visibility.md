# Workload Visibility Plugin User Guide for Application Developers

This document describes how to utilize the Workload Visibility plugin.

## Overview

The Workload Visibility plugin enables developers to view their running Kubernetes workloads and learn about their details and statuses. Gaining visibility helps developers debug and troubleshoot issues associated with their workloads.

## Before you begin

The developer needs to perform the below actions in order to see their running workloads on the dashboard:<br/>

* Create a YAML file specifying the components and label/s used to identify the workloads.
* Push the YAML file to the repo that is registered with Backstage. (The system operator must already have registered the company/org-wide repository in the Backstage configuration.)


## Navigate to the Workload Visibility Plugin

To view the list of your running workloads:<br/>

* Click on the component that you want to see from the catalog on the landing page.
* Once you are in the component page, click on the ‘Workloads’ tab on the top navigation menu.<br/>

In this screen, you can view the list of running workloads, along with their overall status, type, namespace and cluster they belong to, age and the public URL (if any).

<img width="1879" alt="workload-visibility-workloadlist" src="https://user-images.githubusercontent.com/55402754/139098340-819054fc-220e-4075-9c5f-cd92675a81e1.png">

## Resource Details Pages

### Knative Service Details

In order to view further details of your workloads, you can click on your desired workload from the list. In the screenshot below, Knative service details are displayed such as:<br/>

* Status Conditions
* Annotations
* Labels
* Incoming Routes
* Revisions (you can view more details of each revision by clicking on them)
* Pods (you can view each pod details by clicking on them

<img width="1682" alt="workload-visibility-knative-details" src="https://user-images.githubusercontent.com/55402754/139098617-13387c68-7c70-4050-becb-fd7309ca611a.png">

### Pod Detail Page

You can gain further information about the pods associated with a service by clicking on the Pod name. The Pod page includes details such as:<br/>

* Status Conditions
* Ownership: provides a detailed hierarchy of the pod belonging to which component
* Annotations
* Labels
* Containers: provides details like Container ID, Image and Ready Status

<img width="1533" alt="workload-visibility-pod-details" src="https://user-images.githubusercontent.com/55402754/139098678-09eb69ac-2bab-4a7f-87e3-bb0ea239365e.png">
