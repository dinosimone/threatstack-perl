# ThreatStack API Client for Perl

Threat Stack is a provider of cloud security management and compliance solutions delivered using a software as a service model. This is a Perl wrapper for the ThreatStack API service.


## Installation

To install this module, run the following commands:

    cpanm WebService::ThreatStack


## Configuration

    use WebService::ThreatStack;

    my $ts = WebService::ThreatStack->new(
        api_key => '[your-api-key]',
        debug   => 1
    );


## Usage


### List agents

List all agents assigned to your active organization.

    my $agent_list = $ts->agents(
        page  => 0,
        count => 20,
        start => '2015-04-01',
        end   => '2017-07-01'
    );


### Get agent by ID

Get details of a specific agent resource. The id to use is id, not agent_id.

    my $agent_info = $ts->agent_by_id(id => $id);


### Get alerts

This URI retrieves all recent alerts related to your current active organization.

    my $alerts = $ts->alerts(
        count => 20,
        start => "2017-07-01",
        end   => "2017-07-20"
    );


### Get alert by ID

Every alert has a URI to fetch specific information about it. Additionally, each alert has a 
latest_events and rule attributes that provides events related to that alert and rule triggered 
respectively.

    my $alert_info = $ts->alert_by_id(id => $alert_id);


### Get policies

Policies object manage the alerts that will be triggered when certain events matches.
A default policy is applied to each agent on creation and custom ones can be created or 
assigned via the User Interface. Note that we’ve introduced the term ruleset to supersede 
policies – the API will be updated shortly, but any existing references to policies 
will still work as expected.

    my $policies = $ts->policies();


### Get policy by ID

Retrieve details of a single policy object.

    my $policy_info = $ts->policy_by_id(id => $policy_id);


### Get organizations 

This resource retrieve all organizations you own or are part of.

    my $organizations = $ts->organizations();


### Get organization users

This resource retrieves all users that are part of your default or active (if you 
use the organization parameter). To change the context just add organization={ORG_ID} 
to do requests on that organization context.

    my $organization_users = $ts->organization_users(id => $organization_id);


### Get audit logs

Get all audit logs

    my $audit_logs = $ts->audit_logs(
        page  => 0,
        count => 20,
        start => "2015-04-01",
        end   => "2017-07-01"
    );


### Search audit logs

Using the q parameter you can do arbitrary search on logs that match that 
specific string pattern. For example, you can do search of q=queue, 
q=john.doe@example.com, etc.

    my $log_results = $ts->search_logs(q => "PCI");



## Support and Documentation

After installing, you can find documentation for this module with the
perldoc command.

    perldoc WebService::ThreatStack

You can also look for information at:

    RT, CPAN's request tracker (report bugs here)
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-ThreatStack

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/WebService-ThreatStack

    CPAN Ratings
        http://cpanratings.perl.org/d/WebService-ThreatStack

    Search CPAN
        http://search.cpan.org/dist/WebService-ThreatStack/


## Disclaimer

This project and the code therein was not created by and is not supported by ThreatStack.


## Author

Dino Simone (dino@simone.is)

