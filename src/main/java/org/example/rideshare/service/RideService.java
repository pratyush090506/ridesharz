package org.example.rideshare.service;

import org.example.rideshare.dto.CreateRideRequest;
import org.example.rideshare.dto.RideResponse;
import org.example.rideshare.exception.BadRequestException;
import org.example.rideshare.exception.NotFoundException;
import org.example.rideshare.exception.UnauthorizedException;
import org.example.rideshare.model.Ride;
import org.example.rideshare.model.User;
import org.example.rideshare.repository.RideRepository;
import org.example.rideshare.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RideService {

    @Autowired
    private RideRepository rideRepository;

    @Autowired
    private UserRepository userRepository;

    public RideResponse createRide(String username, CreateRideRequest request) {
        // Get user by username
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new NotFoundException("User not found"));

        // Create ride
        Ride ride = new Ride();
        ride.setUserId(user.getId());
        ride.setPickupLocation(request.getPickupLocation());
        ride.setDropLocation(request.getDropLocation());
        ride.setStatus("REQUESTED");
        ride.setCreatedAt(new Date());

        Ride savedRide = rideRepository.save(ride);
        return mapToResponse(savedRide);
    }

    public List<RideResponse> getUserRides(String username) {
        // Get user by username
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new NotFoundException("User not found"));

        List<Ride> rides = rideRepository.findByUserId(user.getId());
        return rides.stream().map(this::mapToResponse).collect(Collectors.toList());
    }

    public List<RideResponse> getPendingRides() {
        List<Ride> rides = rideRepository.findByStatus("REQUESTED");
        return rides.stream().map(this::mapToResponse).collect(Collectors.toList());
    }

    public RideResponse acceptRide(String driverUsername, String rideId) {
        // Get driver by username
        User driver = userRepository.findByUsername(driverUsername)
                .orElseThrow(() -> new NotFoundException("Driver not found"));

        // Get ride
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new NotFoundException("Ride not found"));

        // Validate ride status
        if (!ride.getStatus().equals("REQUESTED")) {
            throw new BadRequestException("Ride is not in REQUESTED status");
        }

        // Accept ride
        ride.setDriverId(driver.getId());
        ride.setStatus("ACCEPTED");

        Ride updatedRide = rideRepository.save(ride);
        return mapToResponse(updatedRide);
    }

    public RideResponse completeRide(String username, String rideId) {
        // Get user by username
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new NotFoundException("User not found"));

        // Get ride
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new NotFoundException("Ride not found"));

        // Validate ride status
        if (!ride.getStatus().equals("ACCEPTED")) {
            throw new BadRequestException("Ride is not in ACCEPTED status");
        }

        // Validate authorization (only the passenger or assigned driver can complete)
        if (!ride.getUserId().equals(user.getId()) && !user.getId().equals(ride.getDriverId())) {
            throw new UnauthorizedException("You are not authorized to complete this ride");
        }

        // Complete ride
        ride.setStatus("COMPLETED");

        Ride updatedRide = rideRepository.save(ride);
        return mapToResponse(updatedRide);
    }

    private RideResponse mapToResponse(Ride ride) {
        RideResponse response = new RideResponse();
        response.setId(ride.getId());
        response.setUserId(ride.getUserId());
        response.setDriverId(ride.getDriverId());
        response.setPickupLocation(ride.getPickupLocation());
        response.setDropLocation(ride.getDropLocation());
        response.setStatus(ride.getStatus());
        response.setCreatedAt(ride.getCreatedAt());
        return response;
    }
}
