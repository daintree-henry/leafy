package com.devwiki.leafy.controller.plantLog;

import com.devwiki.leafy.dto.plantLog.PlantLogDto;
import com.devwiki.leafy.dto.plantLog.PlantLogSimpleDto;
import com.devwiki.leafy.service.plantLog.PlantLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/plant-logs")
@RequiredArgsConstructor
public class PlantLogController {

    private final PlantLogService plantLogService;

    /**
     * Get all plant logs
     *
     * @return list of all plant logs
     */
    @GetMapping("")
    public ResponseEntity<List<PlantLogSimpleDto>> getAllPlantLogs() {
        List<PlantLogSimpleDto> plantLogDtoList = plantLogService.getAllPlantLogs();
        return new ResponseEntity<>(plantLogDtoList, HttpStatus.OK);
    }

    /**
     * Get all plant logs of a specific user
     *
     * @return list of all plant logs
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PlantLogSimpleDto>> getAllPlantLogsByUserId(@PathVariable Long userId) {
        List<PlantLogSimpleDto> plantLogDtoList = plantLogService.getAllPlantLogsByUserId(userId);
        return new ResponseEntity<>(plantLogDtoList, HttpStatus.OK);
    }


    /**
     * Get the plant logs of a specific user (latest 5)
     *
     * @return list of all plant logs
     */
    @GetMapping("/recent/user/{userId}")
    public ResponseEntity<List<PlantLogSimpleDto>> getAllPlantRecentLogsByUserId(@PathVariable Long userId) {
        List<PlantLogSimpleDto> plantLogDtoList = plantLogService.getAllPlantLogsByUserId(userId)
                .stream().limit(4)
                .collect(Collectors.toList());
        return new ResponseEntity<>(plantLogDtoList, HttpStatus.OK);
    }

    /**
     * Get a plant log by ID
     *
     * @param plantLogId ID of the plant log to look up
     * @return the plant log found
     */
    @GetMapping("/{plantLogId}")
    public ResponseEntity<PlantLogSimpleDto> getPlantLogById(@PathVariable Long plantLogId) {
        PlantLogSimpleDto plantLogDto = plantLogService.getPlantLogById(plantLogId);
        return new ResponseEntity<>(plantLogDto, HttpStatus.OK);
    }

    /**
     * Get all logs for a user plant
     *
     * @param userPlantId user plant ID
     * @return list of all logs for the user plant
     */
    @GetMapping("/user-plants/{userPlantId}")
    public ResponseEntity<List<PlantLogSimpleDto>> getAllPlantLogsByUserPlantId(@PathVariable Long userPlantId) {
        List<PlantLogSimpleDto> plantLogDtoList = plantLogService.getAllPlantLogsByUserPlantId(userPlantId);
        return new ResponseEntity<>(plantLogDtoList, HttpStatus.OK);
    }

    /**
     * Add a plant log
     *
     * @param plantLogDto plant log to add
     * @return the added plant log
     */
    @PostMapping("")
    public ResponseEntity<PlantLogSimpleDto> addPlantLog(@RequestBody @Valid PlantLogDto plantLogDto) {
        PlantLogSimpleDto addedPlantLogDto = plantLogService.addPlantLog(plantLogDto);
        return new ResponseEntity<>(addedPlantLogDto, HttpStatus.CREATED);
    }

    /**
     * Update a plant log
     *
     * @param plantLogId  ID of the plant log to update
     * @param plantLogDto plant log information to update
     * @return the updated plant log
     */
    @PutMapping("/{plantLogId}")
    public ResponseEntity<PlantLogSimpleDto> updatePlantLog(@PathVariable Long plantLogId, @RequestBody @Valid PlantLogDto plantLogDto) {
        PlantLogSimpleDto updatedPlantLogDto = plantLogService.updatePlantLog(plantLogId, plantLogDto);
        return new ResponseEntity<>(updatedPlantLogDto, HttpStatus.OK);
    }

    /**
     * Delete a plant log
     *
     * @param plantLogId ID of the plant log to delete
     */
    @DeleteMapping("/{plantLogId}")
    public ResponseEntity<Void> deletePlantLog(@PathVariable Long plantLogId) {
        plantLogService.deletePlantLog(plantLogId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
