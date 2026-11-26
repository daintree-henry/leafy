package com.devwiki.leafy.service.plant;

import com.devwiki.leafy.dto.plant.PlantDetailDto;
import com.devwiki.leafy.dto.plant.PlantMapper;
import com.devwiki.leafy.exception.ResourceNotFoundException;
import com.devwiki.leafy.model.plant.Plant;
import com.devwiki.leafy.repository.plant.PlantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlantService {

    private final PlantRepository plantRepository;

    /**
     * Get all plants
     *
     * @return all plants
     */
    public List<PlantDetailDto> getAllPlants() {
        return plantRepository.findAll()
                .stream()
                .map(PlantMapper::toDetailDto)
                .sorted(Comparator.comparing(PlantDetailDto::getCreatedAt).reversed())
                .collect(Collectors.toList());
    }

    /**
     * Get a specific plant
     *
     * @param plantId ID of the plant to look up
     * @return the specified plant
     */
    public PlantDetailDto getPlantById(Long plantId) {
        Plant plant = findPlantById(plantId);
        return PlantMapper.toDetailDto(plant);
    }

    /**
     * Add a plant
     *
     * @param plantDetailDto plant information to add
     * @return the added plant
     */
    @Transactional
    public PlantDetailDto addPlant(PlantDetailDto plantDetailDto) {
        plantDetailDto.setCreatedAt(LocalDateTime.now());
        plantDetailDto.setUpdatedAt(LocalDateTime.now());
        Plant plant = new Plant(plantDetailDto);
        plantRepository.save(plant);
        return PlantMapper.toDetailDto(plant);
    }

    /**
     * Update a plant
     *
     * @param plantDetailDto plant information to update
     * @return the updated plant
     * @throws ResourceNotFoundException if the plant does not exist
     */
    @Transactional
    public PlantDetailDto updatePlant(Long plantId, PlantDetailDto plantDetailDto) {
        Plant plant = findPlantById(plantId);
        plant.updateEntity(plantDetailDto);
        plantRepository.save(plant);
        return PlantMapper.toDetailDto(plant);
    }

    /**
     * Delete a plant
     *
     * @param plantId ID of the plant to delete
     * @throws ResourceNotFoundException if the plant does not exist
     */
    @Transactional
    public void deletePlant(Long plantId) {
        Plant plant = findPlantById(plantId);
        plantRepository.delete(plant);
    }

    /**
     * Get the plant with the given ID
     *
     * @param plantId ID of the plant to look up
     * @return the plant found
     * @throws ResourceNotFoundException if the plant does not exist
     */
    private Plant findPlantById(Long plantId) {
        return plantRepository.findById(plantId)
                .orElseThrow(() -> new ResourceNotFoundException("Plant", "id", plantId));
    }

}
