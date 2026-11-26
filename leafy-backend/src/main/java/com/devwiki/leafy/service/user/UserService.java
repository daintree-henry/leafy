package com.devwiki.leafy.service.user;

import com.devwiki.leafy.dto.user.*;
import com.devwiki.leafy.exception.ResourceNotFoundException;
import com.devwiki.leafy.model.user.User;
import com.devwiki.leafy.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    /**
     * Get all users
     *
     * @return list of all users
     */
    public List<UserResponseDto> getAllUsers() {
        List<User> userDtos = userRepository.findAll();
        return userDtos.stream().map(UserMapper::toResponseDto).collect(Collectors.toList());
    }

    /**
     * Get a user by ID
     *
     * @param userId ID of the user to look up
     * @return the user found
     */
    public UserResponseDto getUserResponseById(Long userId) {
        User user = findUserById(userId);
        return UserMapper.toResponseDto(user);
    }

    /**
     * Get a user by ID (for internal use only)
     *
     * @param userId ID of the user to look up
     * @return the user found
     */
    public UserDto getUserById(Long userId) {
        User user = findUserById(userId);
        return UserMapper.toDto(user);
    }


    /**
     * Creates a new user.
     *
     * @param userRequestDto information for the new user
     * @return the created user
     */
    public UserResponseDto createUser(UserRequestDto userRequestDto) {
        userRequestDto.setCreatedAt(LocalDateTime.now());
        userRequestDto.setUpdatedAt(LocalDateTime.now());
        userRequestDto.setPassword(passwordEncoder.encode(userRequestDto.getPassword())); // Encrypt the password
        User user = new User(userRequestDto);
        userRepository.save(user);
        return UserMapper.toResponseDto(user);
    }

    /**
     * Finds a user by email and password.
     *
     * @param email    user email
     * @param password user password
     * @return the user found
     */
    public UserResponseDto getUserByEmailAndPassword(String email, String password) {
        Optional<User> userOptional = userRepository.findByEmail(email);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (passwordEncoder.matches(password, user.getPassword())) {
                return UserMapper.toResponseDto(user);
            }
        }
        return new UserResponseDto();
    }

    /**
     * Updates a user.
     *
     * @param userPutRequestDto user information to update
     * @return the updated user
     */
    public UserResponseDto updateUser(Long userId, UserPutRequestDto userPutRequestDto) {
        UserRequestDto userRequestDto = new UserRequestDto();
        userRequestDto.setName(userPutRequestDto.getName());
        userRequestDto.setUpdatedAt(LocalDateTime.now());
        // Encrypt the password
        if (userPutRequestDto.getPassword() != null) {
            userRequestDto.setPassword(passwordEncoder.encode(userPutRequestDto.getPassword()));
        }

        User user = findUserById(userId);
        userRequestDto.setEmail(user.getEmail());
        userRequestDto.setGender(user.getGender());
        userRequestDto.setBirthDate(user.getBirthDate());
        userRequestDto.setCreatedAt(user.getCreatedAt());

        user.updateEntity(userRequestDto);
        userRepository.save(user);

        return UserMapper.toResponseDto(user);
    }


    /**
     * Deletes a user.
     *
     * @param userId ID of the user to delete
     */
    public void deleteUser(Long userId) {
        User user = findUserById(userId);
        userRepository.delete(user);
    }

    /**
     * Get the plant log with the given ID
     */
    private User findUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("PlantLog", "id", userId));
    }
}
