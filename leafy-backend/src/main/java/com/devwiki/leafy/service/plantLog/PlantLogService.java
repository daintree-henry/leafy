package com.devwiki.leafy.service.plantLog;

import com.devwiki.leafy.dto.plantLog.PlantLogDto;
import com.devwiki.leafy.dto.plantLog.PlantLogMapper;
import com.devwiki.leafy.dto.plantLog.PlantLogSimpleDto;
import com.devwiki.leafy.dto.userPlant.UserPlantDto;
import com.devwiki.leafy.exception.ResourceNotFoundException;
import com.devwiki.leafy.model.plantLog.PlantLog;
import com.devwiki.leafy.repository.plantLog.PlantLogRepository;
import com.devwiki.leafy.service.userPlant.UserPlantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlantLogService {

    private final PlantLogRepository plantLogRepository;
    private final UserPlantService userPlantService;

    /**
     * Get all plant logs
     *
     * @return list of all plant logs
     */
    public List<PlantLogSimpleDto> getAllPlantLogs() {
        List<PlantLog> plantLogs = plantLogRepository.findAll();
        return plantLogs.stream().map(PlantLogMapper::toSimpleDto).collect(Collectors.toList());
    }

    /**
     * Get all plant logs of a user
     *
     * @return list of all plant logs
     */
    public List<PlantLogSimpleDto> getAllPlantLogsByUserId(Long userId) {
        List<PlantLog> plantLogs = plantLogRepository.findAllByUserPlant_User_UserId_OrderByLogDateDesc(userId);
        return plantLogs.stream().map(PlantLogMapper::toSimpleDto).collect(Collectors.toList());
    }

    /**
     * Get a plant log by ID
     *
     * @param plantLogId ID of the plant log to look up
     * @return the plant log found
     */
    public PlantLogSimpleDto getPlantLogById(Long plantLogId) {
        PlantLog plantLog = findPlantLogById(plantLogId);
        return PlantLogMapper.toSimpleDto(plantLog);
    }

    /**
     * Get all logs for a user plant
     *
     * @param userPlantId user plant ID
     * @return list of all logs for the user plant
     */
    public List<PlantLogSimpleDto> getAllPlantLogsByUserPlantId(Long userPlantId) {
        List<PlantLog> plantLogs = plantLogRepository.findAllByUserPlant_UserPlantId_OrderByLogDateDesc(userPlantId);
        return plantLogs.stream().map(PlantLogMapper::toSimpleDto).collect(Collectors.toList());
    }

    /**
     * Add a plant log
     *
     * @param plantLogDto plant log to add
     * @return the added plant log
     */
    @Transactional
    public PlantLogSimpleDto addPlantLog(PlantLogDto plantLogDto) {
        plantLogDto.setCreatedAt(LocalDateTime.now());
        plantLogDto.setUpdatedAt(LocalDateTime.now());

        // Check that the UserPlant exists
        UserPlantDto userPlantDto = userPlantService.getUserPlantById(plantLogDto.getUserPlant().getUserPlantId());
        plantLogDto.setUserPlant(userPlantDto);

        // Convert to an entity and save
        PlantLog plantLog = PlantLogMapper.toEntity(plantLogDto);
        plantLogRepository.save(plantLog);
        return PlantLogMapper.toSimpleDto(plantLog);
    }

    /**
     * Update a plant log
     *
     * @param plantLogDto plant log information to update
     * @return the updated plant log
     * @throws ResourceNotFoundException if the plant log does not exist
     */
    @Transactional
    public PlantLogSimpleDto updatePlantLog(Long plnatLogId, PlantLogDto plantLogDto) {
        plantLogDto.setUpdatedAt(LocalDateTime.now());
        PlantLog plantLog = findPlantLogById(plnatLogId);
        plantLog.updateEntity(plantLogDto);
        plantLogRepository.save(plantLog);
        return PlantLogMapper.toSimpleDto(plantLog);
    }


    /**
     * Delete a plant log
     *
     * @param plantLogId ID of the plant log to update
     * @return the updated plant log
     * @throws ResourceNotFoundException if the plant log does not exist
     */
    @Transactional
    public void deletePlantLog(Long plantLogId) {
        PlantLog plantLog = findPlantLogById(plantLogId);
        plantLogRepository.delete(plantLog);
    }

    /**
     * Get the plant log with the given ID
     */
    private PlantLog findPlantLogById(Long plantLogId) {
        return plantLogRepository.findById(plantLogId)
                .orElseThrow(() -> new ResourceNotFoundException("PlantLog", "id", plantLogId));
    }
}