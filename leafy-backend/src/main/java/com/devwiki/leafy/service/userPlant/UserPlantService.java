package com.devwiki.leafy.service.userPlant;

import com.devwiki.leafy.dto.plant.PlantDetailDto;
import com.devwiki.leafy.dto.user.UserDto;
import com.devwiki.leafy.dto.userPlant.UserPlantDto;
import com.devwiki.leafy.dto.userPlant.UserPlantMapper;
import com.devwiki.leafy.dto.userPlant.UserPlantSimpleDto;
import com.devwiki.leafy.exception.ResourceNotFoundException;
import com.devwiki.leafy.model.plantLog.PlantLog;
import com.devwiki.leafy.model.user.User;
import com.devwiki.leafy.model.userPlant.UserPlant;
import com.devwiki.leafy.repository.plantLog.PlantLogRepository;
import com.devwiki.leafy.repository.userPlant.UserPlantRepository;
import com.devwiki.leafy.service.plant.PlantService;
import com.devwiki.leafy.service.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserPlantService {

    private final UserPlantRepository userPlantRepository;
    private final UserService userService;
    private final PlantService plantService;
    private final PlantLogRepository plantLogRepository;

    /**
     * Get all plants a specific user owns
     *
     * @param userId ID of the user to look up
     * @return all plants the user owns
     * @throws ResourceNotFoundException if the user does not exist
     */
    public List<UserPlantSimpleDto> getUserPlantsByUserIdWithWaterRequired(Long userId) {
        UserDto userDto = userService.getUserById(userId);
        List<UserPlant> userPlants = userPlantRepository.findAllByUser(new User(userDto));
        List<UserPlantSimpleDto> userPlantSimpleDtos = new ArrayList<>();

        for (UserPlant userPlant : userPlants) {
            if (userPlant.getPlant() == null) {
                userPlantSimpleDtos.add(UserPlantMapper.toSimpleDto(userPlant));
                continue;
            }
            int waterInterval = userPlant.getPlant().getWateringInterval();
            Optional<LocalDateTime> lastWateredAt = plantLogRepository.findAllByUserPlant_UserPlantId_OrderByLogDateDesc(userPlant.getUserPlantId())
                    .stream().filter(PlantLog::isWatered)
                    .map(PlantLog::getCreatedAt)
                    .findFirst();

            if (lastWateredAt.isPresent()) {
                UserPlantSimpleDto userPlantSimpleDto = UserPlantMapper.toSimpleDto(userPlant);
                userPlantSimpleDto.setWaterRequired(lastWateredAt.get().plusDays(waterInterval).isBefore(LocalDateTime.now()));
                userPlantSimpleDtos.add(userPlantSimpleDto);
            } else {
                UserPlantSimpleDto userPlantSimpleDto = UserPlantMapper.toSimpleDto(userPlant);
                userPlantSimpleDto.setWaterRequired(true);
                userPlantSimpleDtos.add(userPlantSimpleDto);
            }

        }

        return userPlantSimpleDtos;
    }

    /**
     * Get a specific plant the user owns
     *
     * @param userPlantId ID of the user plant to look up
     * @return the specified plant the user owns
     * @throws ResourceNotFoundException if the user plant does not exist
     */
    public UserPlantSimpleDto getSimpleUserPlantById(Long userPlantId) {
        UserPlant userPlant = userPlantRepository.findById(userPlantId)
                .orElseThrow(() -> new ResourceNotFoundException("UserPlant", "id", userPlantId));
        return UserPlantMapper.toSimpleDto(userPlant);
    }

    /**
     * Get a specific plant the user owns
     *
     * @param userPlantId ID of the user plant to look up
     * @return the specified plant the user owns
     * @throws ResourceNotFoundException if the user plant does not exist
     */
    public UserPlantDto getUserPlantById(Long userPlantId) {
        UserPlant userPlant = userPlantRepository.findById(userPlantId)
                .orElseThrow(() -> new ResourceNotFoundException("UserPlant", "id", userPlantId));
        return UserPlantMapper.toDto(userPlant);
    }

    /**
     * Update a specific plant the user owns
     *
     * @param userPlantDto user plant information to update
     * @return the updated user plant
     * @throws ResourceNotFoundException if the user plant does not exist
     */
    @Transactional
    public UserPlantSimpleDto updateUserPlant(Long userPlantId, UserPlantDto userPlantDto) {
        userPlantDto.setUpdatedAt(LocalDateTime.now());
        UserPlant userPlant = userPlantRepository.findById(userPlantId)
                .orElseThrow(() -> new ResourceNotFoundException("UserPlant", "id", userPlantDto.getUserPlantId()));
        userPlant.updateEntity(userPlantDto);
        userPlantRepository.save(userPlant);
        return UserPlantMapper.toSimpleDto(userPlant);
    }

    /**
     * Delete a specific plant the user owns
     *
     * @param userPlantId ID of the user plant to delete
     * @throws ResourceNotFoundException if the user plant does not exist
     */
    @Transactional
    public void deleteUserPlant(Long userPlantId) {
        UserPlant userPlant = userPlantRepository.findById(userPlantId)
                .orElseThrow(() -> new ResourceNotFoundException("UserPlant", "id", userPlantId));
        userPlantRepository.delete(userPlant);
    }

    /**
     * Add a plant the user owns
     *
     * @param userPlantDto user plant information to add
     * @return the added user plant
     * @throws ResourceNotFoundException if the user or the plant does not exist
     */
    @Transactional
    public UserPlantSimpleDto addUserPlant(UserPlantDto userPlantDto) {
        // Creation time
        userPlantDto.setCreatedAt(LocalDateTime.now());
        userPlantDto.setUpdatedAt(LocalDateTime.now());

        // Look up the user and the plant, then add
        UserDto userDto = userService.getUserById(userPlantDto.getUser().getUserId());
        userPlantDto.setUser(userDto);
        PlantDetailDto plantDetailDto = plantService.getPlantById(userPlantDto.getPlant().getPlantId());
        userPlantDto.setPlant(plantDetailDto);

        // Add the user plant
        UserPlant userPlant = new UserPlant(userPlantDto);
        userPlantRepository.save(userPlant);

        return UserPlantMapper.toSimpleDto(userPlant);
    }
}