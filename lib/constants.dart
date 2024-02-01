class Consts {
  static const root = "http://165.232.152.201:8080";
  static const signup = "$root/api/auth/signup";
  static const verifyOtp = "$root/api/auth/verify-mobile-otp";
  static const resendOtp = "$root/api/auth/send-mobile-otp";
  static const checkUserName = "$root/api/auth/check-username?username=";
  static const updateUser = "$root/api/user";
  static const signIn = "$root/api/auth/signin";

  // Edited by MHK-MotoVlogs
  static const changePassword = "$root/api/auth/forgot-password";
  static const updateUserProfile = "$root/api/user/update-profile-picture";
  static const doKyc = "$root/api/kyc/do-kyc";
  static const getKyc = '$root/api/kyc/';
  static const getContacts = '$root/api/user/contacts';
  static const blockContact = '$root/api/user/contacts/block';
  static const unBlockContact = '$root/api/user/contacts/unblock';
  static const removeContact = '$root/api/user/contacts/remove';
  static const addContact = '$root/api/user/contacts/send-request';
  static const unSendRequest = '$root/api/user/contacts/unsend-request';
  static const connectionRequests = '$root/api/user/contacts/requests';
  static const acceptRequest = '$root/api/user/contacts/accept-request';
  static const rejectRequest = '$root/api/user/contacts/reject-request';
  static const sentRequests = '$root/api/user/contacts/contact-request-sent';
  static const saveMasterPin = '$root/api/user/master-pin';
  static const verifyMasterPin = '$root/api/user/master-pin/verify';
  static const webSocketPersonalChatUrl = 'ws://165.232.152.201:8080/chat';
  static const createChatGroup = '$root/api/group/create?group_name=';
  static const getGroupChatData = '$root/api/group?group_id=';
  static const uploadChatGroupImage = '$root/api/group/update-group-picture';
  static const webSocketGroupChatUrl =
      'ws://165.232.152.201:8080/personal-chat';
  //end
  static const getUserById = '$root/api/user/';
}


// {{url_local}}/api/chat/heads?page=0&size=2