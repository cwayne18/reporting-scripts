# reporting-scripts
Reporting scripts to generate reports/stats of Github repos

## Usage
To use this script, you must have the [github cli](https://cli.github.com/) installed.  After installation, you'll need to login:

`gh auth login`

Once authentication, simply run `generate_weekly_report.sh`, which takes one argument, the repo name.  For example to run against k3, run `generate_weekly_report.sh k3s-io/k3s`.  This generates a weekly report in markdown, ready to be updated manually if required, and uploaded as a github discussion.