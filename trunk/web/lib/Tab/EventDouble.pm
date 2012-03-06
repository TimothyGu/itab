package Tab::Class;
use base 'Tab::DBI';
Tab::Class->table('class');
Tab::Class->columns(Primary =>qw/id/);
Tab::Class->columns(Essential => qw/name tourn double_entry timestamp max judge_group/);
Tab::Class->has_many(events => "Tab::Event", 'class');
Tab::Class->has_a(tourn => 'Tab::Tourn');
Tab::Class->has_a(judge_group => 'Tab::JudgeGroup');
