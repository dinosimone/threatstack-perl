#!/usr/bin/perl
##!perl -T
use strict;
use warnings;
use Test::More;
use Test::MockModule;
use WebService::ThreatStack;
use JSON;


plan tests => 10;


my $json = JSON->new;


##
# create mock Rest::Client
my $injected_json = "{}";
my $injected_code = 200;
my $captured_self = undef;
my $captured_resource = "";
my $captured_data = "";
my %called = (GET => 0);

my $mock = Test::MockModule->new('REST::Client');

$mock->mock("GET", sub { ($captured_self, $captured_resource, $captured_data) = @_; $called{GET}++; });
$mock->mock("buildQuery", sub { return " " . JSON::encode_json($_[1]) if $_[1] && keys %{$_[1]}; });
$mock->mock("responseContent", sub { return $injected_json; });
$mock->mock("responseCode", sub { return $injected_code });



my $ts = WebService::ThreatStack->new(
    api_key => '[your-api-key]',
    debug   => 1
);


##
# Test agents listing

$injected_code = 200;
my $agent_list = $ts->agents(
    page  => 0,
    count => 20,
    start => '2015-04-01',
    end   => '2017-07-01'
);
ok($agent_list->{response_code} =~ /^20/, 'Get list of agents');



##
# Test ability to get specific agent by ID

my $agent_id = '59498ac1f5df700b87dfd7f0';
$injected_json = JSON::encode_json({id => $agent_id});
my $agent_info = $ts->agent_by_id(id => $agent_id);
ok($json->decode($agent_info->{response_content})->{id} eq $agent_id, 'Get agent by id');



##
# Test ability to get alerts in date range

$injected_json = JSON::encode_json([{}, {}, {}]);
my $alerts = $ts->alerts(
    count => 20,
    start => "2017-07-01",
    end   => "2017-07-20"
);
my $list = $json->decode($alerts->{response_content});
ok(scalar @$list > 0, "Get alerts");


##
# Test ability to get specific alert

my $alert_id = '596fc1dd1c7ff17fcfff0e9d';
$injected_json = JSON::encode_json({id => $alert_id});
my $alert_info = $ts->alert_by_id(id => $alert_id);
ok($json->decode($alert_info->{response_content})->{id} eq $alert_id, "Get alert by id");



##
# Test ability to get policies

$injected_json = JSON::encode_json([{}, {}, {}]);
my $policies = $ts->policies();
my $policy_list = $json->decode($policies->{response_content});
ok(scalar @$policy_list > 0, "Get all policies");


##
# Test ability to get policy by ID

my $policy_id = 'c7f19f3e-5a94-11e7-bc2f-67738152a9f7';
$injected_json = JSON::encode_json({id => $policy_id});
my $policy_info = $ts->policy_by_id(id => $policy_id);
ok($json->decode($policy_info->{response_content})->{id} eq $policy_id, "Get policy by id");


##
# Test ability to get all organizations

$injected_json = JSON::encode_json([{}, {}, {}]);
my $organizations = $ts->organizations();
ok(scalar @{$json->decode($organizations->{response_content})} > 0, "Get a list of organizations");


##
# Test ability to get organization users by ID

my $organization_id = '55a3d35325e8c77d312bbe0c';
$injected_json = JSON::encode_json([{}]);
my $organization_users = $ts->organization_users(id => $organization_id);
ok(scalar @{$json->decode($organization_users->{response_content})} > 0, "Get a list of organization users");


##
# Test abiltiy to get audit logs

$injected_json = JSON::encode_json([{}]);
my $audit_logs = $ts->audit_logs(
    page  => 0,
    count => 20,
    start => "2015-04-01",
    end   => "2017-07-01"
);
ok(scalar @{$json->decode($audit_logs->{response_content})} > 0, "Get paginated audit logs");


##
# Test ability to search for audit logs

$injected_code = 200;
my $log_results = $ts->search_logs(q => "PCI");
ok($log_results->{response_code} =~ /^20/, "Search audit logs");
