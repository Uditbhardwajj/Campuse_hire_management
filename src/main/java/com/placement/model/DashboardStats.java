package com.placement.model;

public class DashboardStats {
    private int totalStudents;
    private int totalCompanies;
    private int totalJobs;
    private int totalInternships;
    private int totalApplications;
    private int totalPlaced;
    private int pendingCompanies;

    public DashboardStats() {
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalCompanies() {
        return totalCompanies;
    }

    public void setTotalCompanies(int totalCompanies) {
        this.totalCompanies = totalCompanies;
    }

    public int getTotalJobs() {
        return totalJobs;
    }

    public void setTotalJobs(int totalJobs) {
        this.totalJobs = totalJobs;
    }

    public int getTotalInternships() {
        return totalInternships;
    }

    public void setTotalInternships(int totalInternships) {
        this.totalInternships = totalInternships;
    }

    public int getTotalApplications() {
        return totalApplications;
    }

    public void setTotalApplications(int totalApplications) {
        this.totalApplications = totalApplications;
    }

    public int getTotalPlaced() {
        return totalPlaced;
    }

    public void setTotalPlaced(int totalPlaced) {
        this.totalPlaced = totalPlaced;
    }

    public int getPendingCompanies() {
        return pendingCompanies;
    }

    public void setPendingCompanies(int pendingCompanies) {
        this.pendingCompanies = pendingCompanies;
    }
}
