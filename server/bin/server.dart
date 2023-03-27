import 'package:server/core/services/jwt_service.dart';
import 'package:server/entities/friend.dart';
import 'package:server/entities/friend_request.dart';
import 'package:server/entities/user.dart';
import 'package:server/server_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:sqleto/sqleto.dart';

void main() async {
  try {
    final config = SQLetoConfig(
      host: 'host.docker.internal',
      port: 5432,
      database: 'postgres',
      username: 'postgres',
      password: 'postgres',
      schemas: [
        () => UserSchema.empty(),
        () => FriendRequestSchema.empty(),
        () => FriendSchema.empty(),
      ],
    );

    await SQLeto.initialize(config);

    final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(JwtService.jwtMiddleware()).addHandler(ServerModule.resources());

    final server = await io.serve(handler, '0.0.0.0', 3005);

    print('Server running at http://${server.address.host}:${server.port}');
  } on SQLetoException catch (e) {
    print(e.error);
  } on Exception catch (e) {
    print(e.toString());
  }
}
