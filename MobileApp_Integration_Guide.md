# Mobile App Integration Guide - JWT Authentication

## Overview
This guide explains how to integrate JWT token authentication with your mobile app to prevent automatic logout and ensure seamless user experience.

## Authentication Flow

### 1. Initial Login (OTP Verification)
**Endpoint:** `POST /Users/Auth/VerifyOtp.php`

**Request:**
```json
{
  "mobile": "9876543210",
  "otp": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "data": {
    "user_id": 123,
    "mobile": "9876543210",
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "expires_in": 3600,
    "token_type": "Bearer",
    "verified": true,
    "profile_completed": false
  }
}
```

### 2. Save Tokens in SharedPreferences
```javascript
// After successful login
const tokens = {
  access_token: response.data.access_token,
  refresh_token: response.data.refresh_token,
  expires_in: response.data.expires_in,
  token_type: response.data.token_type
};

// Save to SharedPreferences
await AsyncStorage.setItem('auth_tokens', JSON.stringify(tokens));
await AsyncStorage.setItem('user_id', response.data.user_id.toString());
```

## API Calls with Authentication

### 3. Making Authenticated API Calls
```javascript
const makeAuthenticatedRequest = async (url, data) => {
  // Get tokens from storage
  const tokensJson = await AsyncStorage.getItem('auth_tokens');
  const tokens = JSON.parse(tokensJson);
  
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${tokens.access_token}`
    },
    body: JSON.stringify(data)
  });
  
  // Check if token was refreshed
  const newAccessToken = response.headers.get('X-New-Access-Token');
  const newRefreshToken = response.headers.get('X-New-Refresh-Token');
  
  if (newAccessToken) {
    // Update tokens in storage
    const updatedTokens = {
      ...tokens,
      access_token: newAccessToken,
      refresh_token: newRefreshToken
    };
    await AsyncStorage.setItem('auth_tokens', JSON.stringify(updatedTokens));
  }
  
  return response.json();
};
```

## Token Management

### 4. Check Token Status
**Endpoint:** `POST /Users/Auth/CheckTokenStatus.php`

**Request:**
```json
{
  "access_token": "your_access_token",
  "refresh_token": "your_refresh_token"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Token is valid",
  "data": {
    "access_token": "new_access_token_if_refreshed",
    "refresh_token": "new_refresh_token_if_refreshed",
    "expires_in": 3600,
    "token_type": "Bearer",
    "refreshed": true,
    "user": {
      "user_id": 123,
      "mobile": "9876543210",
      "full_name": "John Doe",
      "email": "john@example.com",
      "profile_completed": true,
      "status": "active"
    }
  }
}
```

### 5. Manual Token Refresh
**Endpoint:** `POST /Users/Auth/RefreshToken.php`

**Request:**
```json
{
  "refresh_token": "your_refresh_token"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "access_token": "new_access_token",
    "refresh_token": "new_refresh_token",
    "expires_in": 3600
  }
}
```

## App Lifecycle Integration

### 6. App Startup - Check Authentication
```javascript
const checkAuthenticationStatus = async () => {
  try {
    const tokensJson = await AsyncStorage.getItem('auth_tokens');
    
    if (!tokensJson) {
      // No tokens, redirect to login
      return { isAuthenticated: false, needsLogin: true };
    }
    
    const tokens = JSON.parse(tokensJson);
    
    // Check token status with server
    const response = await fetch('/Users/Auth/CheckTokenStatus.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        access_token: tokens.access_token,
        refresh_token: tokens.refresh_token
      })
    });
    
    const result = await response.json();
    
    if (result.success) {
      // Update tokens if refreshed
      if (result.data.access_token !== tokens.access_token) {
        const updatedTokens = {
          ...tokens,
          access_token: result.data.access_token,
          refresh_token: result.data.refresh_token
        };
        await AsyncStorage.setItem('auth_tokens', JSON.stringify(updatedTokens));
      }
      
      return { 
        isAuthenticated: true, 
        user: result.data.user,
        needsLogin: false 
      };
    } else {
      // Tokens invalid, clear storage and redirect to login
      await AsyncStorage.removeItem('auth_tokens');
      await AsyncStorage.removeItem('user_id');
      return { isAuthenticated: false, needsLogin: true };
    }
    
  } catch (error) {
    console.error('Auth check error:', error);
    return { isAuthenticated: false, needsLogin: true };
  }
};
```

### 7. Background Token Refresh
```javascript
const setupTokenRefresh = () => {
  // Check token status every 30 minutes
  setInterval(async () => {
    const tokensJson = await AsyncStorage.getItem('auth_tokens');
    if (tokensJson) {
      const tokens = JSON.parse(tokensJson);
      
      try {
        const response = await fetch('/Users/Auth/CheckTokenStatus.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            access_token: tokens.access_token,
            refresh_token: tokens.refresh_token
          })
        });
        
        const result = await response.json();
        
        if (result.success && result.data.refreshed) {
          // Update tokens
          const updatedTokens = {
            ...tokens,
            access_token: result.data.access_token,
            refresh_token: result.data.refresh_token
          };
          await AsyncStorage.setItem('auth_tokens', JSON.stringify(updatedTokens));
        }
      } catch (error) {
        console.error('Background refresh error:', error);
      }
    }
  }, 30 * 60 * 1000); // 30 minutes
};
```

## Logout

### 8. User Logout
**Endpoint:** `POST /Users/Auth/Logout.php`

```javascript
const logout = async () => {
  try {
    // Call logout API (optional)
    const tokensJson = await AsyncStorage.getItem('auth_tokens');
    if (tokensJson) {
      const tokens = JSON.parse(tokensJson);
      
      await fetch('/Users/Auth/Logout.php', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${tokens.access_token}`
        }
      });
    }
  } catch (error) {
    console.error('Logout API error:', error);
  } finally {
    // Always clear local storage
    await AsyncStorage.removeItem('auth_tokens');
    await AsyncStorage.removeItem('user_id');
    
    // Redirect to login screen
    navigation.navigate('Login');
  }
};
```

## Security Features

### 9. Token Security
- **Access Token**: Valid for 1 hour
- **Refresh Token**: Valid for 30 days
- **Automatic Refresh**: Tokens refresh automatically when needed
- **Secure Storage**: Tokens stored in device's secure storage (SharedPreferences)
- **No Auto-Logout**: Users stay logged in as long as refresh token is valid

### 10. Error Handling
```javascript
const handleApiError = async (error, response) => {
  if (response?.status === 401) {
    // Token expired or invalid
    const tokensJson = await AsyncStorage.getItem('auth_tokens');
    
    if (tokensJson) {
      const tokens = JSON.parse(tokensJson);
      
      // Try to refresh token
      try {
        const refreshResponse = await fetch('/Users/Auth/RefreshToken.php', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refresh_token: tokens.refresh_token })
        });
        
        const refreshResult = await refreshResponse.json();
        
        if (refreshResult.success) {
          // Update tokens and retry original request
          const updatedTokens = {
            ...tokens,
            access_token: refreshResult.data.access_token,
            refresh_token: refreshResult.data.refresh_token
          };
          await AsyncStorage.setItem('auth_tokens', JSON.stringify(updatedTokens));
          
          // Retry original request here
          return true; // Indicates retry should happen
        }
      } catch (refreshError) {
        console.error('Token refresh failed:', refreshError);
      }
    }
    
    // If refresh fails, redirect to login
    await AsyncStorage.removeItem('auth_tokens');
    await AsyncStorage.removeItem('user_id');
    navigation.navigate('Login');
  }
  
  return false; // Don't retry
};
```

## Benefits

✅ **No Automatic Logout**: Users stay logged in for 30 days
✅ **Seamless Experience**: Automatic token refresh
✅ **Security**: JWT tokens with expiration
✅ **Offline Support**: Tokens cached locally
✅ **Background Refresh**: Tokens refresh automatically
✅ **Error Recovery**: Automatic retry on token refresh

## API Endpoints Summary

| Endpoint | Purpose | Auth Required |
|----------|---------|---------------|
| `/Users/Auth/VerifyOtp.php` | Login/OTP verification | No |
| `/Users/Auth/CheckTokenStatus.php` | Check token validity | No |
| `/Users/Auth/RefreshToken.php` | Manual token refresh | No |
| `/Users/Auth/CompleteProfile.php` | Complete user profile | Yes |
| `/Users/Auth/Logout.php` | User logout | Optional |
| `/Users/Auth/RequestOtp.php` | Request OTP | No |
| `/Users/Auth/ResendOtp.php` | Resend OTP | No |

This implementation ensures your users will never experience automatic logout as long as they use the app within 30 days!
