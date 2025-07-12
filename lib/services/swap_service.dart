import '../models/swap_request_model.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class SwapService {
  static final SwapService _instance = SwapService._internal();
  factory SwapService() => _instance;
  SwapService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // Create a new swap request
  Future<bool> createSwapRequest({
    required int fromUserId,
    required int toUserId,
    required String offeredSkills,
    required String requestedSkills,
  }) async {
    try {
      final request = SwapRequest(
        fromUserId: fromUserId,
        toUserId: toUserId,
        offeredSkills: offeredSkills,
        requestedSkills: requestedSkills,
        status: SwapRequestStatus.pending,
      );

      final requestId = await _databaseService.insertSwapRequest(request);
      return requestId > 0;
    } catch (e) {
      return false;
    }
  }

  // Get all swap requests for a user
  Future<List<SwapRequest>> getUserSwapRequests(int userId) async {
    try {
      return await _databaseService.getSwapRequestsByUserId(userId);
    } catch (e) {
      return [];
    }
  }

  // Get pending requests for a user
  Future<List<SwapRequest>> getPendingRequests(int userId) async {
    try {
      final allRequests = await _databaseService.getSwapRequestsByUserId(userId);
      return allRequests.where((request) => 
        request.status == SwapRequestStatus.pending && 
        request.toUserId == userId
      ).toList();
    } catch (e) {
      return [];
    }
  }

  // Update request status
  Future<bool> updateRequestStatus(int requestId, SwapRequestStatus status) async {
    try {
      final result = await _databaseService.updateSwapRequestStatus(requestId, status);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  // Accept a swap request
  Future<bool> acceptRequest(int requestId) async {
    return await updateRequestStatus(requestId, SwapRequestStatus.accepted);
  }

  // Reject a swap request
  Future<bool> rejectRequest(int requestId) async {
    return await updateRequestStatus(requestId, SwapRequestStatus.rejected);
  }

  // Cancel a swap request
  Future<bool> cancelRequest(int requestId) async {
    return await updateRequestStatus(requestId, SwapRequestStatus.cancelled);
  }

  // Get request details with user information
  Future<Map<String, dynamic>?> getRequestDetails(int requestId) async {
    try {
      final requests = await _databaseService.getSwapRequestsByUserId(0); // Get all requests
      final request = requests.firstWhere((r) => r.id == requestId);
      
      if (request != null) {
        final fromUser = await _databaseService.getUserById(request.fromUserId);
        final toUser = await _databaseService.getUserById(request.toUserId);
        
        return {
          'request': request,
          'fromUser': fromUser,
          'toUser': toUser,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 