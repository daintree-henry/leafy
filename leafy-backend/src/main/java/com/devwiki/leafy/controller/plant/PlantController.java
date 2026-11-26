package com.devwiki.leafy.controller.plant;

import com.devwiki.leafy.dto.plant.PlantDetailDto;
import com.devwiki.leafy.service.plant.PlantService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/v1/plants")
@RequiredArgsConstructor
public class PlantController {

    private final PlantService plantService;

    /**
     * Get all plants
     *
     * @return list of all plants
     */
    @GetMapping("")
    public ResponseEntity<List<PlantDetailDto>> getAllPlants() {
        List<PlantDetailDto> plantDetailDtoList = plantService.getAllPlants();
        return new ResponseEntity<>(plantDetailDtoList, HttpStatus.OK);
    }

    /**
     * Get a plant by ID
     *
     * @param plantId ID of the plant to look up
     * @return the plant found
     */
    @GetMapping("/{plantId}")
    public ResponseEntity<PlantDetailDto> getPlantById(@PathVariable Long plantId) {
        PlantDetailDto plantDetailDto = plantService.getPlantById(plantId);
        return new ResponseEntity<>(plantDetailDto, HttpStatus.OK);
    }

    /**
     * Add a plant
     *
     * @param plantDetailDto plant to add
     * @return the added plant
     */
    @PostMapping("")
    public ResponseEntity<PlantDetailDto> addPlant(@Valid @RequestBody PlantDetailDto plantDetailDto) {
        PlantDetailDto addedPlantDetailDto = plantService.addPlant(plantDetailDto);
        return new ResponseEntity<>(addedPlantDetailDto, HttpStatus.CREATED);
    }


    /**
     * Update a plant
     *
     * @param plantId   ID of the plant to update
     * @param plantDetailDto  plant information to update
     * @return the updated plant
     */
    @PutMapping("/{plantId}")
    public ResponseEntity<PlantDetailDto> updatePlant(@PathVariable Long plantId, @RequestBody PlantDetailDto plantDetailDto) {
        PlantDetailDto updatedPlantDetailDto = plantService.updatePlant(plantId, plantDetailDto);
        return new ResponseEntity<>(updatedPlantDetailDto, HttpStatus.OK);
    }

    /**
     * Delete a plant
     *
     * @param plantId ID of the plant to delete
     */
    @DeleteMapping("/{plantId}")
    public ResponseEntity<Void> deletePlant(@PathVariable Long plantId) {
        plantService.deletePlant(plantId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
