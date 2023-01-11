import 'package:commitlint_types/commitlint_types.dart';

RuleConfig extractRuleConfig(dynamic config) {
  if (config is! List) {
    throw Exception('rule config must be list, but get $config');
  }
  if (config.isEmpty || config.length < 2 || config.length > 3) {
    throw Exception('rule config must contain at least two, at most three items.');
  }
  final severity = _extractRuleConfigSeverity(config.first as int);
  final condition = _extractRuleConfigCondition(config.elementAt(1) as String);
  dynamic value;
  if (config.length == 3) {
    value = config.last;
  }
  if (value is num) {
    return LengthRuleConfig(
      severity: severity,
      condition: condition,
      length: value,
    );
  }
  if (value is String) {
    if (value.endsWith('-case')) {
      return CaseRuleConfig(
        severity: severity,
        condition: condition,
        type: _extractCase(value),
      );
    } else {
      return ValueRuleConfig<String>(
        severity: severity,
        condition: condition,
        value: value,
      );
    }
  }
  if (value is List) {
    return EnumRuleConfig(
      severity: severity,
      condition: condition,
      allowed: value.cast(),
    );
  }
  return ValueRuleConfig(
    severity: severity,
    condition: condition,
    value: value,
  );

}

RuleConfigSeverity _extractRuleConfigSeverity(int severity) {
  if (severity < 0 || severity > RuleConfigSeverity.values.length - 1) {
    throw Exception('rule severity can only be 0..${RuleConfigSeverity.values.length - 1}');
  }
  return RuleConfigSeverity.values[severity];

}

RuleConfigCondition _extractRuleConfigCondition(String condition) {
  var allowed = RuleConfigCondition.values.map((e) => e.name).toList();
  final index = allowed.indexOf(condition);
  if (index == -1) {
    throw Exception('rule condition can only one of $allowed');
  }
  return RuleConfigCondition.values[index];
}

Case _extractCase(String name) {
  var allowed = Case.values.map((e) => e.caseName).toList();
  final index = allowed.indexOf(name);
  if (index == -1) {
    throw Exception('rule case can only one of $allowed');
  }
  return Case.values[index];
}