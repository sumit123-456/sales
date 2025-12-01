package com.sales.sales.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "call_details")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CallDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long callId;
    @Column(name = "emp_id")
    private String empId;
    private LocalDate callDate;
    private String callType;
    private String disposition;
    private int duration;
    private String team;

    // JOIN added here ⬇️
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "emp_id",
            referencedColumnName = "empId",
            insertable = false,
            updatable = false
    )
    private LeadDetail lead;
}
