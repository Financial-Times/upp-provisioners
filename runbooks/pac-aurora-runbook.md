<!--
    Written in the format prescribed by https://github.com/Financial-Times/runbook.md.
    Any future edits should abide by this format.
-->
# PAC Aurora DB

Amazon Aurora MySQL DB cluster used by PAC to persist draft annotations and content.

## Code

pac-aurora

## Primary URL

prod-rds-pac.ft.com

## Service Tier

Platinum

## Lifecycle Stage

Production

## Host Platform

AWS

## Architecture

The PAC Aurora database is an Amazon Aurora MySQL RDS cluster of 4 database instances spread between two AWS regions - eu-west-1 and us-east-1.

Regional DNS architecture;
<https://www.lucidchart.com/publicSegments/view/b0f16f1b-6393-45ff-91a6-d1da1274e722/image.png>

Broader architecture diagram:
<https://www.lucidchart.com/publicSegments/view/22c1656b-6242-4da6-9dfb-f7225c20f38f/image.png>

## Contains Personal Data

No

## Contains Sensitive Data

No

<!-- Placeholder - remove HTML comment markers to activate
## Can Download Personal Data
Choose Yes or No

...or delete this placeholder if not applicable to this system
-->

<!-- Placeholder - remove HTML comment markers to activate
## Can Contact Individuals
Choose Yes or No

...or delete this placeholder if not applicable to this system
-->

## Failover Architecture Type

ActivePassive

## Failover Process Type

PartiallyAutomated

## Failback Process Type

Manual

## Failover Details

The failover is fully automatic and managed by AWS.
If someone wants to trigger manually a failover, the guide for that is located here:
<https://github.com/Financial-Times/upp-provisioners/tree/master/pac-aurora-provisioner#automated-failover-between-two-regions>

## Data Recovery Process Type

Manual

## Data Recovery Details

The PAC Aurora backup is executed as a daily K8S cron job which performs an AWS snapshot.
Check <https://runbooks.in.ft.com/pac-aurora-backup> for more details.

The restoration instructions can be found here:
<https://github.com/Financial-Times/upp-provisioners/blob/master/pac-aurora-provisioner/README.md#provisioning-a-cluster-from-an-existing-database-snapshot>

## Release Process Type

PartiallyAutomated

## Rollback Process Type

Manual

## Release Details

For release details check:
<https://github.com/Financial-Times/upp-provisioners/blob/master/pac-aurora-provisioner/README.md>

<!-- Placeholder - remove HTML comment markers to activate
## Heroku Pipeline Name
Enter descriptive text satisfying the following:
This is the name of the Heroku pipeline for this system. If you don't have a pipeline, this is the name of the app in Heroku. A pipeline is a group of Heroku apps that share the same codebase where each app in a pipeline represents the different stages in a continuous delivery workflow, i.e. staging, production.

...or delete this placeholder if not applicable to this system
-->

## Key Management Process Type

Manual

## Key Management Details

Manually created AWS IAM "pac-content-provisioner" user credentials are used during provisioning only.

## Monitoring

<div>
    <p>PAC components monitor their own database connection via the FT standard healthchecks. Additionally, there is a "PAC Aurora DB" Heimdall tile which checks Aurora directly via Cloudwatch.</p>
    <p>Cloudwatch alarms for PAC Aurora are prepended with <b>pac-aurora-prod</b>&nbsp;and check the following metrics for both database instances within a region:</p>
    <ul>
        <li>Engine Uptime - this determines whether the database instance is running or not. This is the only alarm which will turn the Dashing tile CRITICAL when it fails.</li>
        <li>CPU Utilization and CPU Credit Balance - these alerts fire when our CPU usage is unsustainably high.</li>
        <li>Freeable Memory - these alerts fire when our database instances are low on memory.</li>
        <li>Replica Lag - this alert fires when the database replica (in the same region) is significantly behind the primary.</li>
    </ul>
    <p>The PAC Aurora PROD EU and US tiles in Dashing change depending on the status of the Cloudwatch alarms; simply click the tile to see which alarms are firing within that region (you will need to login to the AWS Content Prod account first).</p>
    <p>Here are the Cloudwatch alarms for <a href="https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#alarmsV2:?~(search~'pac-aurora-prod~alarmStateFilter~'ALL~alarmTypeFilter~'ALL~currentPageIndex~'1)" target="_blank">PROD EU</a> and <a href="https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:?~(search~'pac-aurora-prod~alarmStateFilter~'ALL~alarmTypeFilter~'ALL~currentPageIndex~'1)" target="_blank">PROD US</a>.</p>
</div>

## First Line Troubleshooting

<div>
    <p>The PAC Aurora DB consists of 4 database instances spread between two AWS regions, <b>eu-west-1</b> and <b>us-east-1</b>. PAC applications connect to the master database cluster which resides in one region, and is formed of two database instances. These instances are spread across two availability zones for additional local resiliency in each region. A replica cluster resides in the other region, and is also formed of two instances.</p>
    <p>Failures to database instances within a region are handled <b>automatically</b> by Aurora, which means that no intervention is required. In case of an outage to the entire primary AWS region, or in case of a RED "PAC Aurora DB" Heimdall Tile, please use this <a href="https://sites.google.com/a/ft.com/universal-publishing/ops-guides/pac-aurora-failover" target="_blank">failover guide</a>.
    </p>
</div>

<https://github.com/Financial-Times/upp-docs/tree/master/guides/ops/first-line-troubleshooting>

## Second Line Troubleshooting

Check the AWS console for details, or:

<https://sites.google.com/a/ft.com/universal-publishing/ops-guides/pac-aurora-failover>
<https://sites.google.com/a/ft.com/universal-publishing/ops-guides/pac-aurora-manual-failover>
<https://sites.google.com/a/ft.com/universal-publishing/documentation/pac/aurora-backup-and-restore>
<https://sites.google.com/a/ft.com/universal-publishing/documentation/pac/pac-aurora-disaster-recovery-process>