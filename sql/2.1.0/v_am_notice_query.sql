if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_am_notice_query]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_am_notice_query]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.v_am_notice_query
AS
SELECT an.guid, an.notice_type, an.dispatching_number, an.notice_state, 
      an.notice_department, an.datetime_begin, an.datetime_end, an.title, 
      an.data_create_user, an.data_create_time, tc1.CODENAME AS notice_type_name, 
      tc2.CODENAME AS notice_state_name, 
      td.department_name AS notice_department_name, an.attachment, an.is_need_receipt,
          (SELECT COUNT(useraccount)
         FROM am_notice_receiver
         WHERE notice_type = an.notice_type) AS notice_receiver_count,
          (SELECT COUNT(data_create_user)
         FROM am_notice_receipt
         WHERE notice_guid = an.guid) AS notice_read_count,
          (SELECT COUNT(is_receipted)
         FROM am_notice_receipt
         WHERE notice_guid = an.guid AND is_receipted = 1) 
      AS notice_receipted_count
FROM dbo.am_notice an INNER JOIN
      dbo.t_codediction tc1 ON an.notice_type = tc1.CODEVALUE AND 
      tc1.CODETYPE = 'notice_type' INNER JOIN
      dbo.t_codediction tc2 ON tc2.CODETYPE = 'notice_state' AND 
      tc2.CODEVALUE = an.notice_state INNER JOIN
      dbo.t_department td ON td.department_id = an.notice_department

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


exec sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "an"
            Begin Extent = 
               Top = 24
               Left = 286
               Bottom = 127
               Right = 474
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tc1"
            Begin Extent = 
               Top = 19
               Left = 37
               Bottom = 122
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tc2"
            Begin Extent = 
               Top = 39
               Left = 629
               Bottom = 142
               Right = 781
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "td"
            Begin Extent = 
               Top = 145
               Left = 563
               Bottom = 248
               Right = 733
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 240
      Begin ColumnWidths = 14
         Width = 284
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
         Width = 1440
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410', N'user', N'dbo', N'view', N'v_am_notice_query'
GO
exec sp_addextendedproperty N'MS_DiagramPane2', N'
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', N'user', N'dbo', N'view', N'v_am_notice_query'
GO
exec sp_addextendedproperty N'MS_DiagramPaneCount', 2, N'user', N'dbo', N'view', N'v_am_notice_query'

GO

