package com.devwiki.leafy.controller.userPlant;

import com.devwiki.leafy.dto.userPlant.UserPlantDto;
import com.devwiki.leafy.dto.userPlant.UserPlantSimpleDto;
import com.devwiki.leafy.service.userPlant.UserPlantService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/v1/user-plants")
@RequiredArgsConstructor
public class UserPlantController {

    private final UserPlantService userPlantService;

    /**
     * Get all plants the user owns
     *
     * @param userId ID of the user to look up
     * @return all plants the user owns
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<UserPlantSimpleDto>> getUserPlantsByUserId(@PathVariable Long userId) {
        List<UserPlantSimpleDto> userPlantDtoList = userPlantService.getUserPlantsByUserIdWithWaterRequired(userId);
        return new ResponseEntity<>(userPlantDtoList, HttpStatus.OK);
    }

    /**
     * Get a specific plant the user owns
     *
     * @param userPlantId ID of the user plant to look up
     * @return the specified plant the user owns
     */
    @GetMapping("/{userPlantId}")
    public ResponseEntity<UserPlantSimpleDto> getUserPlantById(@PathVariable Long userPlantId) {
        UserPlantSimpleDto userPlantDto = userPlantService.getSimpleUserPlantById(userPlantId);
        return new ResponseEntity<>(userPlantDto, HttpStatus.OK);
    }

    /**
     * Add a plant the user owns
     *
     * @param userPlantDto user plant information to add
     * @return the added user plant
     */
    @PostMapping("")
    public ResponseEntity<UserPlantSimpleDto> addUserPlant(@RequestBody @Valid UserPlantDto userPlantDto) {
        UserPlantSimpleDto addedUserPlantDto = userPlantService.addUserPlant(userPlantDto);
        return new ResponseEntity<>(addedUserPlantDto, HttpStatus.CREATED);
    }


    /**
     * Update a specific plant the user owns
     *
     * @param userPlantId  ID of the user plant to update
     * @param userPlantDto user plant information to update
     * @return the updated user plant
     */
    @PutMapping("/{userPlantId}")
    public ResponseEntity<UserPlantSimpleDto> updateUserPlant(@PathVariable Long userPlantId, @RequestBody UserPlantDto userPlantDto) {
        UserPlantSimpleDto updatedUserPlantDto = userPlantService.updateUserPlant(userPlantId, userPlantDto);
        return new ResponseEntity<>(updatedUserPlantDto, HttpStatus.OK);
    }

    /**
     * Delete a specific plant the user owns
     *
     * @param userPlantId ID of the user plant to delete
     */
    @DeleteMapping("/{userPlantId}")
    public ResponseEntity<Void> deleteUserPlant(@PathVariable Long userPlantId) {
        userPlantService.deleteUserPlant(userPlantId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
