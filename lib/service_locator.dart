import 'package:get_it/get_it.dart';
import 'package:quiz_app/common/bloc/token_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_list_user_cubit.dart';
import 'package:quiz_app/core/constant/socket_service.dart';
import 'package:quiz_app/data/auth/repository_imp/auth_repository_imp.dart';
import 'package:quiz_app/data/auth/service/auth_service.dart';
import 'package:quiz_app/data/conversation/repository_imp/conversation_repository_imp.dart';
import 'package:quiz_app/data/conversation/service/conversation_service.dart';
import 'package:quiz_app/data/post/repository_imp/post_repository_imp.dart';
import 'package:quiz_app/data/post/service/post_service.dart';
import 'package:quiz_app/data/question/repository_imp/question_repository_imp.dart';
import 'package:quiz_app/data/question/service/question_service.dart';
import 'package:quiz_app/data/quiz/repository_imp/quiz_repository_imp.dart';
import 'package:quiz_app/data/quiz/service/quiz_service.dart';
import 'package:quiz_app/data/team/repository_imp/team_repository_imp.dart';
import 'package:quiz_app/data/team/service/team_service.dart';
import 'package:quiz_app/data/user/repository_imp/user_repository_imp.dart';
import 'package:quiz_app/data/user/service/user_service.dart';
import 'package:quiz_app/domain/auth/repository/auth_repository.dart';
import 'package:quiz_app/domain/auth/usecase/login_usecase.dart';
import 'package:quiz_app/domain/auth/usecase/register_usecase.dart';
import 'package:quiz_app/domain/conversation/repository/conversation_repository.dart';
import 'package:quiz_app/domain/conversation/usecase/get_list_conversation_usecase.dart';
import 'package:quiz_app/domain/conversation/usecase/get_message_usecase.dart';
import 'package:quiz_app/domain/post/repository/post_repository.dart';
import 'package:quiz_app/domain/post/usecase/add_post_usecase.dart';
import 'package:quiz_app/domain/post/usecase/get_comment_usecase.dart';
import 'package:quiz_app/domain/post/usecase/get_list_post_use_case.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';
import 'package:quiz_app/domain/question/usecase/get_list_practice_usecase.dart';
import 'package:quiz_app/domain/question/usecase/get_list_question_usecase.dart';
import 'package:quiz_app/domain/question/usecase/get_my_question_usecase.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/domain/quiz/usecase/add_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/edit_quiz_detail_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_leader_board_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_my_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_result_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_newest_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_quiz_detail_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_recent_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/remove_question_from_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/search_list_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/submit_result_usecase.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/domain/team/usecase/add_quiz_to_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/add_request_join_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/delete_request_join_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/get_list_request_usecase.dart';
import 'package:quiz_app/domain/team/usecase/get_list_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/get_team_detail_usecase.dart';
import 'package:quiz_app/domain/team/usecase/remove_quiz_from_team_usecase.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';
import 'package:quiz_app/domain/user/usecase/accept_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/add_friend_usecase.dart';
import 'package:quiz_app/domain/user/usecase/cancel_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/change_profile_usecase.dart';
import 'package:quiz_app/domain/user/usecase/delete_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_list_user_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_user_detail_usecase.dart';

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
  sl.registerSingleton<UserService>(UserServiceImp());
  sl.registerSingleton<ConversationService>(ConversationServiceImp());
//repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImp());
  sl.registerSingleton<QuizRepository>(QuizRepositoryImp());
  sl.registerSingleton<QuestionRepository>(QuestionRepositoryImp());
  sl.registerSingleton<TeamRepository>(TeamRepositoryImp());
  sl.registerSingleton<PostRepository>(PostRepositoryImp());
  sl.registerSingleton<UserRepository>(UserRepositoryImp());
  sl.registerSingleton<ConversationRepository>(ConversationRepositoryImp());
//usecase


  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase());



  //quiz
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
  sl.registerSingleton<SubmitResultUseCase>(SubmitResultUseCase());
  sl.registerSingleton<GetLeaderBoardUseCase>(GetLeaderBoardUseCase());
  sl.registerSingleton<GetListResultUseCase>(GetListResultUseCase());

  //question
  sl.registerSingleton<GetListPracticeUsecase>(GetListPracticeUsecase());
  sl.registerSingleton<GetMyQuestionUseCase>(GetMyQuestionUseCase());

//team
  sl.registerSingleton<GetListTeamUseCase>(GetListTeamUseCase());
  sl.registerSingleton<AddRequestJoinTeamUseCase>(AddRequestJoinTeamUseCase());
  sl.registerSingleton<DeleteRequestJoinTeamUseCase>(DeleteRequestJoinTeamUseCase());
  sl.registerSingleton<GetListRequestUseCase>(GetListRequestUseCase());
  sl.registerSingleton<AddQuizToTeamUseCase>(AddQuizToTeamUseCase());
  sl.registerSingleton<RemoveQuizFromTeamUseCase>(RemoveQuizFromTeamUseCase());
  sl.registerSingleton<GetTeamDetailUseCase>(GetTeamDetailUseCase());
  //user
  sl.registerSingleton<GetUserDetailUseCase>(GetUserDetailUseCase());
  sl.registerSingleton<ChangeProfileUseCase>(ChangeProfileUseCase());
  sl.registerSingleton<AddFriendUseCase>(AddFriendUseCase());
  sl.registerSingleton<CancelFriendRequestUseCase>(CancelFriendRequestUseCase());
  sl.registerSingleton<AcceptFriendRequestUseCase>(AcceptFriendRequestUseCase());
  sl.registerSingleton<DeleteFriendRequestUseCase>(DeleteFriendRequestUseCase());
  sl.registerSingleton<GetFriendRequestUseCase>(GetFriendRequestUseCase());
  sl.registerSingleton<GetFriendUseCase>(GetFriendUseCase());
  sl.registerSingleton<GetListUserUseCase>(GetListUserUseCase());
  //post
  sl.registerSingleton<AddPostUseCase>(AddPostUseCase());
  sl.registerSingleton<GetListPostUseCase>(GetListPostUseCase());
  sl.registerSingleton<GetCommentUseCase>(GetCommentUseCase());
  //token
  sl.registerSingleton<TokenService>(TokenService());
  sl.registerFactory(() => ApiService(sl<TokenService>()));

  //conversation
  //sl.registerSingleton<SocketService>(SocketService());
  sl.registerLazySingleton(() => SocketService(sl<TokenService>()));


  sl.registerSingleton<GetListConversationUseCase>(GetListConversationUseCase());
  sl.registerSingleton<GetMessageUseCase>(GetMessageUseCase());
  sl.registerFactory<TokenCubit>(() => TokenCubit(sl<TokenService>()));
}
