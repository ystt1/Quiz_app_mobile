import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/data/quiz/models/topic_model.dart';
abstract class QuizService {
  Future<Either> addQuizService();

  Future<Either> addQuestionToQuizService();

  Future<Either> editQuizDetailService();

  Future<Either> getHotQuizService();

  Future<Either> getListMyQuizService();

  Future<Either> getListQuizOfTeamService();

  Future<Either> getNewestQuizService();

  Future<Either> getQuizDetailService();

  Future<Either> getRecentQuizService();

  Future<Either> removeQuestionFromQuizService();

  Future<Either> searchListQuizService();

  Future<Either> getAllTopic();
}

class QuizServiceImp extends QuizService {
  final List<BasicQuizModel> mockData = [
    BasicQuizModel(
      id: "quiz1",
      name: "Basic Mathematics",
      description: "Test your fundamental math skills with this quiz.",
      numberQues: 10,
      time: 15,
      topics: ["Math", "Numbers", "Algebra"],
      imgUrl:
          "https://static.vecteezy.com/system/resources/previews/013/115/384/non_2x/cartoon-maths-elements-background-education-logo-vector.jpg",
    ),
    BasicQuizModel(
      id: "quiz2",
      name: "World Geography",
      description: "Explore the world with this geography quiz.",
      numberQues: 20,
      time: 30,
      topics: ["Geography", "World", "Continents"],
      imgUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSovM8Vjr1A2zEK5yfqTv1tAn8hT-silDWAHA&s",
    ),
    BasicQuizModel(
      id: "quiz3",
      name: "History Trivia",
      description: "Challenge yourself with historical facts and events.",
      numberQues: 15,
      time: 20,
      topics: ["History", "Ancient", "Modern"],
      imgUrl:
          "https://static.vecteezy.com/system/resources/previews/002/236/242/non_2x/history-minimal-thin-line-icons-set-vector.jpg",
    ),
    BasicQuizModel(
      id: "quiz4",
      name: "Science Fundamentals",
      description: "A basic quiz on various science topics.",
      numberQues: 12,
      time: 18,
      topics: ["Science", "Biology", "Physics"],
      imgUrl:
          "https://static.vecteezy.com/system/resources/thumbnails/000/202/093/small_2x/Science-Fair2-Vectors.jpg",
    ),
    BasicQuizModel(
      id: "quiz5",
      name: "Programming Basics",
      description: "Test your knowledge of basic programming concepts.",
      numberQues: 25,
      time: 40,
      topics: ["Programming", "Coding", "Algorithms"],
      imgUrl:
          "https://bairesdev.mo.cloudinary.net/blog/2023/08/How-to-Choose-the-Right-Programming-Language-for-a-New-Project.jpg",
    ),
  ];

  @override
  Future<Either> addQuestionToQuizService() {
    // TODO: implement addQuestionToQuizService
    throw UnimplementedError();
  }

  @override
  Future<Either> addQuizService() {
    // TODO: implement addQuizService
    throw UnimplementedError();
  }

  @override
  Future<Either> editQuizDetailService() {
    // TODO: implement editQuizDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> getHotQuizService() async {
    try {
      return Right(mockData);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListMyQuizService() async {
    try {
      return Right(mockData);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListQuizOfTeamService() {
    // TODO: implement getListQuizOfTeamService
    throw UnimplementedError();
  }

  @override
  Future<Either> getNewestQuizService() async {
    try {
      return Right(mockData);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuizDetailService() {
    // TODO: implement getQuizDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> getRecentQuizService() async {
    try {
      return Right(mockData);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> removeQuestionFromQuizService() {
    // TODO: implement removeQuestionFromQuizService
    throw UnimplementedError();
  }

  @override
  Future<Either> searchListQuizService() async{
    try {
      return Right(mockData);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllTopic() async {
    try {
      final uri = Uri.parse('http://localhost:5000/api/topic');
      final response = await http.get(uri);
      if(response.statusCode==200)
      {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final topics = data.map((topic) => TopicModel.fromMap(topic)).toList();
        return Right(topics);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
