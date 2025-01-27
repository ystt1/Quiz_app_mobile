import 'package:get_it/get_it.dart';
import 'package:quiz_app/data/auth/repository_imp/auth_repository_imp.dart';
import 'package:quiz_app/data/auth/service/auth_service.dart';
import 'package:quiz_app/data/post/repository_imp/post_repository_imp.dart';
import 'package:quiz_app/data/post/service/post_service.dart';
import 'package:quiz_app/data/question/repository_imp/question_repository_imp.dart';
import 'package:quiz_app/data/question/service/question_service.dart';
import 'package:quiz_app/data/quiz/repository_imp/quiz_repository_imp.dart';
import 'package:quiz_app/data/quiz/service/quiz_service.dart';
import 'package:quiz_app/data/team/repository_imp/team_repository_imp.dart';
import 'package:quiz_app/data/team/service/team_service.dart';
import 'package:quiz_app/domain/auth/repository/auth_repository.dart';
import 'package:quiz_app/domain/auth/usecase/login_usecase.dart';
import 'package:quiz_app/domain/auth/usecase/register_usecase.dart';
import 'package:quiz_app/domain/post/repository/post_repository.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';
import 'package:quiz_app/domain/question/usecase/get_list_question_usecase.dart';
import 'package:quiz_app/domain/question/usecase/get_my_question_usecase.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/domain/quiz/usecase/add_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/edit_quiz_detail_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_my_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_newest_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_quiz_detail_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_recent_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/remove_question_from_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/search_list_quiz_usecase.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';

import 'data/api_service.dart';
import 'domain/quiz/usecase/get_all_topic_usecase.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
//service
  sl.registerSingleton<AuthService>(AuthServiceImp());
  sl.registerSingleton<QuizService>(QuizServiceImp());
  sl.registerSingleton<QuestionService>(QuestionServiceImp());
  sl.registerSingleton<TeamService>(TeamServiceImp());
  sl.registerSingleton<PostService>(PostServiceImp());
//repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImp());
  sl.registerSingleton<QuizRepository>(QuizRepositoryImp());
  sl.registerSingleton<QuestionRepository>(QuestionRepositoryImp());
  sl.registerSingleton<TeamRepository>(TeamRepositoryImp());
  sl.registerSingleton<PostRepository>(PostRepositoryImp());
//usecase
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());


  sl.registerSingleton<GetHotQuizUseCase>(GetHotQuizUseCase());
  sl.registerSingleton<GetRecentQuizUseCase>(GetRecentQuizUseCase());
  sl.registerSingleton<GetNewestQuizUseCase>(GetNewestQuizUseCase());
  sl.registerSingleton<GetListMyQuizUseCase>(GetListMyQuizUseCase());
  sl.registerSingleton<SearchListQuizUseCase>(SearchListQuizUseCase());
  sl.registerSingleton<GetAllTopicUseCase>(GetAllTopicUseCase());
  sl.registerSingleton<AddQuizUseCase>(AddQuizUseCase());
  sl.registerSingleton<GetQuizDetailUseCase>(GetQuizDetailUseCase());
  sl.registerSingleton<RemoveQuestionFromQuizUseCase>(RemoveQuestionFromQuizUseCase());
  sl.registerSingleton<EditQuizDetailUseCase>(EditQuizDetailUseCase());
  //question
  sl.registerSingleton<GetListQuestionUseCase>(GetListQuestionUseCase());
  sl.registerSingleton<GetMyQuestionUseCase>(GetMyQuestionUseCase());



  sl.registerSingleton<TokenService>(TokenService());
  sl.registerFactory(() => ApiService(sl<TokenService>()));
}
