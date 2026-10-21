# UPP - K8s Jumpbox

coco-jumpoff.in.ft.com is the UPP jumpbox for Ops connection to the UPP k8s (delivery, publishing) clusters

## Code

upp-k8s-jumpbox

## Primary URL

https://github.com/Financial-Times/upp-provisioners/tree/master/content-jumpbox-provisioner

## Service Tier

Silver

## Lifecycle Stage

Production

## Host Platform

AWS

## Monitoring

Check the EC2 instance status in the AWS Console.

## Monitoring Opt Out Reason

uses a bespoke monitoring as Problem hub doesn't pick these up

## Architecture

The jumpbox is an EC2 instance base on FT Base image and located in the EU West 1 AWS region.
By logging into it using their Active Directory credentials users are able to connect to the UPP k8s (delivery, publishing, PAC) clusters.

## First Line Troubleshooting

Check the documentation in the repository for troubleshooting details.

<!-- ## Second Line Troubleshooting
Enter descriptive text satisfying the following:
Troubleshooting information for members of the system's support or delivery team.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

## Failover Architecture Type

None

## Failover Process Type

None

## Failback Process Type

None

<!-- ## Failover Details
Enter descriptive text satisfying the following:
The actions required to fail this system from one region to another. Either provide a set of numbered steps or a link to a detailed process that operations can follow.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Data Backup Process Type
Choose from FullyAutomated, PartiallyAutomated, Manual, NotApplicable, None

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Data Backup Location
Choose from NothingToBackup, NotWorthBackingUp, Delegated, OnFinancialTimesNetwork, OffFinancialTimesNetwork, AtFinancialTimesVendor, None

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Reason For Data Backup Exemption
Enter descriptive text satisfying the following:
Explanation of why data backups are not performed for this system.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Data Backup Frequency
Choose from NoBackups, Hourly, Daily, Weekly, Monthly, Quarterly, Yearly, Adhoc

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Data Backup Details
Enter descriptive text satisfying the following:
The actions required to backup the data for this system. Either provide a set of numbered steps or a link to a detailed process that operations can follow.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

## Data Recovery Process Type

NotApplicable

## Data Recovery Details

The system does not store any data.

## Release Process Type

Manual

## Rollback Process Type

Manual

## Release Details

Check the repo for more details on the release process:
https://github.com/Financial-Times/upp-provisioners/tree/master/content-jumpbox-provisioner

<!-- ## Change Log Opt Out Reason
Enter descriptive text satisfying the following:
Some systems cannot be hooked up to automated change logs. Please briefly explain why here.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Secret Management Tools
Choose one or more from 
- None
- AWSSecretsManager
- AWSParamStore
- Doppler
- onePassword


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

## Key Management Process Type

NotApplicable

## Key Management Details

To login to the instance users need to enter their `Firstname.Lastname` Active Directory credentials which need to have the appropriate AD groups attached.

## Contains Personal Data

No

## Contains Sensitive Data

No

<!-- *************************************************************
******************** OPTIONAL FIELDS *****************************
******************************************************************

Below here are fields that you may add to your RUNBOOK.md if you wish,
but it's not recommended to do so because either:
- They may need to be updated by non-technical people or people outside your team
- They document some non-technical aspect of the system
- They may need to be updated on a schedule totally unrelated to your system's release lifecycleStage

Many of the fields that meet those conditions are related to data governance
or access controls.

However, if you find it convenient to maintain the documentation for these in your
RUNBOOK.md file, you are free to do so. If you'd rather follow our advice and not
include them then simply delete this comment and everything below.

******************************************************************
******************************************************************
************************************************************** -->


## Support Contact Preference

SystemOwner

<!-- ## Last Data Restore Date
Enter descriptive text satisfying the following:
The date that the last data restore was run for this system.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Api Gateway Key Rotation Opt In
Enter descriptive text satisfying the following:
When enabled, API Gateway keys are automatically rotated for this system.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Stores Personal Data
Choose Yes or No

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Can Download Personal Data
Choose Yes or No

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Can Contact Individuals
Choose Yes or No

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Gdpr Retention Process
Choose from AutomaticChasingEmail, DeletionTable, ScheduledPurge, API, Manual, Multiple, NotApplicable

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Gdpr Retention Process Last Run Date
Enter descriptive text satisfying the following:
The date when the personal data stored in the system were last checked as complying with the retention policy.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Gdpr Hub Sar Integration
Choose from AutomaticChasingEmail, API

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Gdpr Hub Erasure Integration
Choose from AutomaticChasingEmail, API

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Gdpr Erasure Process
Choose from AutomaticChasingEmail, DeletionTable, ScheduledPurge, API, Manual, Multiple, NotApplicable

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Risk
Enter descriptive text satisfying the following:
More details of what kind of data is held/processed in this system, and what the associated risks are.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Has Admin Accounts
Choose Yes or No

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Admin Access Process
Enter descriptive text satisfying the following:
Describe how you manage administrative accounts. How you add and remove users from
administrative level groups. You can find more information and a template in TechHub at https://tech.in.ft.com/tech-topics/security/admin_process.
This field can be populated with a link to existing documentation or used as the
documentation itself.


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Admin Access Last Reviewed Date
Enter descriptive text satisfying the following:
A timestamp when those with Admin permissions were last reviewed, this will then raise an issue
when 6 months have elapsed - which is a requirement of Cyber Essentials.


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Authentication Methods
Choose one or more from 
- OktaSSO
- GoogleSSO
- MicrosoftEntraSSO
- GitHubAuth
- Auth0
- UserNameAndPassword
- MFASoftwareToken
- MFAHardwareDevice
- FTVPNAccess
- FTInternalNetwork
- Citrix
- IPAllowList
- APIEndpointStaticKey
- NotRequired


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Authentication Policies
Choose one or more from 
- FailureLockout
- LongPassword
- UniqueAccount


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Audit Requirements
Choose one or more from 
- CyberEssentials
- PCICompliance
- AccessibilityAudit
- DigitalSubscriptionsAudit
- FinancialAudit


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Cyber Essentials Opt Out Reason
Enter descriptive text satisfying the following:
Some third systems are considered out-of-scope for Cyber Essentials.  Use this field to explain why we have deemed a given system to be out-of-scope.  To be filled out by, or in collaboration with, the Cyber Security team.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Certifications
Choose one or more from 
- CyberEssentials2023
- CyberEssentials2022
- PCICompliance


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Api Documentation Link
Enter descriptive text satisfying the following:
The url where documentation for users of this API is located. (Leave blank if system has no API intended for use by teams other than the maintainers).


Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## More Information
Enter descriptive text satisfying the following:
Any additional information about this system.

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->

<!-- ## Future Plans
Enter descriptive text satisfying the following:
Information regarding significant future changes intended for this system (including replacing, replatforming or decommissioning).

Uncomment to include in your RUNBOOK.md, or delete this entire block if not applicable to this system.
-->
	