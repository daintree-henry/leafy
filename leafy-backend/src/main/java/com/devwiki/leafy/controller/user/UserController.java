package com.devwiki.leafy.controller.user;

import com.devwiki.leafy.dto.user.LoginDto;
import com.devwiki.leafy.dto.user.UserPutRequestDto;
import com.devwiki.leafy.dto.user.UserRequestDto;
import com.devwiki.leafy.dto.user.UserResponseDto;
import com.devwiki.leafy.service.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * Get all users
     *
     * @return list of all users
     */
    @GetMapping("")
    public ResponseEntity<List<UserResponseDto>> getAllUsers() {
        List<UserResponseDto> userResponseDtoList = userService.getAllUsers();
        return new ResponseEntity<>(userResponseDtoList, HttpStatus.OK);
    }

    /**
     * Get a user by ID
     *
     * @param userId ID of the user to look up
     * @return the user found
     */
    @GetMapping("/{userId}")
    public ResponseEntity<UserResponseDto> getUserById(@PathVariable Long userId) {
        UserResponseDto userResponseDto = userService.getUserResponseById(userId);
        return new ResponseEntity<>(userResponseDto, HttpStatus.OK);
    }

    /**
     * Add a new user
     *
     * @param userRequestDto user information to add
     * @return the added user
     */
    @PostMapping("")
    public ResponseEntity<UserResponseDto> addUser(@Valid @RequestBody UserRequestDto userRequestDto) {
        UserResponseDto addedUserResponseDto = userService.createUser(userRequestDto);
        return new ResponseEntity<>(addedUserResponseDto, HttpStatus.CREATED);
    }

    /**
     * Update a user
     *
     * @param userPutRequestDto user information to update
     * @return the updated user
     */
    @PutMapping("/{userId}")
    public ResponseEntity<UserResponseDto> updateUser(@PathVariable Long userId, @Valid @RequestBody UserPutRequestDto userPutRequestDto) {
        UserResponseDto updatedUserResponseDto = userService.updateUser(userId, userPutRequestDto);
        return new ResponseEntity<>(updatedUserResponseDto, HttpStatus.OK);
    }

    /**
     * Delete a user
     *
     * @param userId ID of the user to delete
     */
    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId) {
        userService.deleteUser(userId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

//    /**
//     * Get the currently authenticated user
//     *
//     * @return authenticated user information
//     */
//    @GetMapping("/current")
//    public ResponseEntity<UserResponseDto> getCurrentUser() {
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
//        UserResponseDto userResponseDto = userService.getUserByEmailAndPassword(userDetails.getUsername(), userDetails.getPassword());
//        return new ResponseEntity<>(userResponseDto, HttpStatus.OK);
//    }

    /**
     * User login
     *
     * @param loginDto login information
     * @return logged-in user information
     */
    @PostMapping("/login")
    public ResponseEntity<UserResponseDto> login(@RequestBody LoginDto loginDto) {
        UserResponseDto userResponseDto = userService.getUserByEmailAndPassword(loginDto.getEmail(), loginDto.getPassword());
        if (userResponseDto.getUserId() != null) {
            return new ResponseEntity<>(userResponseDto, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
    }

}
