class ResponseModel {
  String id;
  String object;
  int created;
  String model;
  List<ChoiceModel> choices;
  UsageModel usage;

  ResponseModel({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices: List<ChoiceModel>.from(
          json['choices'].map((choice) => ChoiceModel.fromJson(choice))),
      usage: UsageModel.fromJson(json['usage']),
    );
  }
}

class ChoiceModel {
  String text;
  int index;
  dynamic logprobs;
  String finishReason;

  ChoiceModel({
    required this.text,
    required this.index,
    required this.logprobs,
    required this.finishReason,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      text: json['text'],
      index: json['index'],
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }
}

class UsageModel {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  UsageModel({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory UsageModel.fromJson(Map<String, dynamic> json) {
    return UsageModel(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}
