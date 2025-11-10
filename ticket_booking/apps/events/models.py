from django.db import models

from apps.accounts.models import Employee

class Team(models.Model):
    team_id = models.AutoField(primary_key=True)
    team_name = models.CharField(max_length=255, unique=True)
    logo = models.ImageField(upload_to='team_logos/', null=True, blank=True, default='team_logos/default.webp')
    head_coach = models.CharField(max_length=255)
    description = models.TextField()

    class Meta:
        db_table = 'team'

    def __str__(self):
        return self.team_name

class Stadium(models.Model):
    stadium_id = models.AutoField(primary_key=True)
    stadium_name = models.CharField(max_length=255, unique=True)
    stadium_code = models.CharField(max_length=5, unique=True)
    location = models.CharField(max_length=255)
    capacity = models.IntegerField(null=True, blank=True)
    stadium_layouts = models.ImageField(upload_to='stadium_layouts/', null=True, blank=True, default='stadium_layouts/stadium-1.png') 

    class Meta:
        db_table = 'stadium'

    def __str__(self):
        return self.stadium_name


class League(models.Model):
    league_id = models.AutoField(primary_key=True)
    league_name = models.CharField(max_length=255)
    league_type = models.IntegerField(default=0)  
    start_date = models.DateField()
    end_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'league'

    def __str__(self):
        return self.league_name


class Match(models.Model):
    match_id = models.AutoField(primary_key=True)
    match_time = models.DateTimeField()
    description = models.TextField()
    stadium = models.ForeignKey(Stadium, on_delete=models.CASCADE)
    league = models.ForeignKey(League, on_delete=models.CASCADE)
    round = models.CharField(max_length=100)
    team_1 = models.ForeignKey(Team, related_name='home_matches', on_delete=models.CASCADE)
    team_2 = models.ForeignKey(Team, related_name='away_matches', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'match'
        constraints = [
            models.UniqueConstraint(fields=['match_time', 'stadium'], name='unique_match_time_stadium'),
            models.UniqueConstraint(fields=['league', 'round', 'team_1', 'team_2'], name='unique_league_round_teams'),
        ]
    
    def __str__(self):
        return f'{self.team_1} vs {self.team_2}'


class MatchHistory(models.Model):
    CHANGE_TYPE_CHOICES = [
        ('update', 'Cập nhật thông tin'),
        ('postpone', 'Hoãn'),
        ('cancel', 'Hủy'),
        ('reschedule', 'Dời lịch thi đấu'),
    ]

    m_history_id = models.AutoField(primary_key=True)
    match = models.ForeignKey(Match, on_delete=models.CASCADE)
    changed_at = models.DateTimeField(auto_now_add=True)
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    change_type = models.CharField(max_length=50, choices=CHANGE_TYPE_CHOICES)
    old_value = models.JSONField()
    new_value = models.JSONField()
    reason = models.TextField()

    class Meta:
        db_table = 'match_history'

    def __str__(self):
        return f'History of {self.match}'
